"""
Unsplash API Client Script
Uses the Unsplash API to search and download photos.
Credentials are loaded from .env file (copy .env.example to .env)
"""

import os
import sys
import json
import argparse
from pathlib import Path
from typing import Optional, List, Dict, Any

import requests
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Unsplash API Configuration
UNSPLASH_API_BASE = "https://api.unsplash.com"
ACCESS_KEY = os.getenv("UNSPLASH_ACCESS_KEY")
SECRET_KEY = os.getenv("UNSPLASH_SECRET_KEY")
APPLICATION_ID = os.getenv("UNSPLASH_APPLICATION_ID")
REDIRECT_URI = os.getenv("UNSPLASH_REDIRECT_URI", "urn:ietf:wg:oauth:2.0:oob")


class UnsplashClient:
    """Client for interacting with the Unsplash API."""

    def __init__(self, access_key: str = None):
        self.access_key = access_key or ACCESS_KEY
        if not self.access_key:
            raise ValueError("Unsplash access key not configured. Set UNSPLASH_ACCESS_KEY in .env")
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Client-ID {self.access_key}",
            "Accept-Version": "v1"
        })

    def search_photos(
        self,
        query: str,
        page: int = 1,
        per_page: int = 10,
        orientation: Optional[str] = None,
        color: Optional[str] = None,
        collections: Optional[List[str]] = None,
        content_filter: str = "high"
    ) -> Dict[str, Any]:
        """
        Search for photos on Unsplash.

        Args:
            query: Search query string
            page: Page number (default: 1)
            per_page: Results per page (default: 10, max: 30)
            orientation: Filter by orientation (landscape, portrait, squarish)
            color: Filter by color (hex or name: black_and_white, black, white, yellow, orange, red, purple, magenta, green, teal, blue)
            collections: List of collection IDs to search within
            content_filter: Content filter (low, high)

        Returns:
            API response with results
        """
        params = {
            "query": query,
            "page": page,
            "per_page": min(per_page, 30),
            "content_filter": content_filter
        }

        if orientation:
            params["orientation"] = orientation
        if color:
            params["color"] = color
        if collections:
            params["collections"] = ",".join(collections)

        response = self.session.get(f"{UNSPLASH_API_BASE}/search/photos", params=params)
        response.raise_for_status()
        return response.json()

    def get_photo(self, photo_id: str) -> Dict[str, Any]:
        """Get a single photo by ID."""
        response = self.session.get(f"{UNSPLASH_API_BASE}/photos/{photo_id}")
        response.raise_for_status()
        return response.json()

    def get_random_photo(
        self,
        query: Optional[str] = None,
        orientation: Optional[str] = None,
        featured: bool = False,
        count: int = 1
    ) -> List[Dict[str, Any]]:
        """Get random photo(s)."""
        params = {"count": min(count, 30)}
        if query:
            params["query"] = query
        if orientation:
            params["orientation"] = orientation
        if featured:
            params["featured"] = "true"

        response = self.session.get(f"{UNSPLASH_API_BASE}/photos/random", params=params)
        response.raise_for_status()
        return response.json()

    def download_photo(self, photo: Dict[str, Any], download_dir: Path = None) -> Path:
        """
        Download a photo and trigger the download tracking.

        Args:
            photo: Photo object from API
            download_dir: Directory to save the photo (default: ./downloads)

        Returns:
            Path to downloaded file
        """
        if download_dir is None:
            download_dir = Path("./downloads")
        download_dir.mkdir(parents=True, exist_ok=True)

        photo_id = photo.get("id")
        if not photo_id:
            raise ValueError("Photo has no ID")

        # Trigger download tracking via API (returns the actual download URL)
        download_response = self.session.get(f"{UNSPLASH_API_BASE}/photos/{photo_id}/download")
        download_response.raise_for_status()
        download_data = download_response.json()
        download_url = download_data.get("url")
        if not download_url:
            raise ValueError("Download URL not returned by API")

        # Download the actual image using the authenticated session
        img_response = self.session.get(download_url, stream=True)
        img_response.raise_for_status()

        # Determine filename
        filename = f"{photo_id}.jpg"
        filepath = download_dir / filename

        with open(filepath, "wb") as f:
            for chunk in img_response.iter_content(chunk_size=8192):
                f.write(chunk)

        print(f"Downloaded: {filepath}")
        return filepath

    def get_user(self, username: str) -> Dict[str, Any]:
        """Get user profile by username."""
        response = self.session.get(f"{UNSPLASH_API_BASE}/users/{username}")
        response.raise_for_status()
        return response.json()

    def get_user_photos(
        self,
        username: str,
        page: int = 1,
        per_page: int = 10,
        order_by: str = "latest"
    ) -> List[Dict[str, Any]]:
        """Get photos by a specific user."""
        params = {"page": page, "per_page": per_page, "order_by": order_by}
        response = self.session.get(f"{UNSPLASH_API_BASE}/users/{username}/photos", params=params)
        response.raise_for_status()
        return response.json()

    def get_collections(self, page: int = 1, per_page: int = 10) -> List[Dict[str, Any]]:
        """Get curated collections."""
        params = {"page": page, "per_page": per_page}
        response = self.session.get(f"{UNSPLASH_API_BASE}/collections", params=params)
        response.raise_for_status()
        return response.json()

    def get_collection(self, collection_id: str) -> Dict[str, Any]:
        """Get a single collection by ID."""
        response = self.session.get(f"{UNSPLASH_API_BASE}/collections/{collection_id}")
        response.raise_for_status()
        return response.json()

    def get_collection_photos(
        self,
        collection_id: str,
        page: int = 1,
        per_page: int = 10
    ) -> List[Dict[str, Any]]:
        """Get photos from a collection."""
        params = {"page": page, "per_page": per_page}
        response = self.session.get(f"{UNSPLASH_API_BASE}/collections/{collection_id}/photos", params=params)
        response.raise_for_status()
        return response.json()


def format_photo_info(photo: Dict[str, Any]) -> str:
    """Format photo information for display."""
    user = photo.get("user", {})
    return (
        f"ID: {photo.get('id')}\n"
        f"Description: {photo.get('description') or photo.get('alt_description') or 'N/A'}\n"
        f"Photographer: {user.get('name')} (@{user.get('username')})\n"
        f"URL: {photo.get('links', {}).get('html')}\n"
        f"Download: {photo.get('links', {}).get('download')}\n"
        f"Dimensions: {photo.get('width')}x{photo.get('height')}\n"
        f"Color: {photo.get('color')}\n"
        f"Likes: {photo.get('likes')}\n"
        f"---\n"
    )


def main():
    parser = argparse.ArgumentParser(description="Unsplash API Client")
    subparsers = parser.add_subparsers(dest="command", help="Commands")

    # Search command
    search_parser = subparsers.add_parser("search", help="Search for photos")
    search_parser.add_argument("query", help="Search query")
    search_parser.add_argument("-p", "--page", type=int, default=1, help="Page number")
    search_parser.add_argument("-n", "--per-page", type=int, default=10, help="Results per page (max 30)")
    search_parser.add_argument("-o", "--orientation", choices=["landscape", "portrait", "squarish"], help="Orientation filter")
    search_parser.add_argument("-c", "--color", help="Color filter")
    search_parser.add_argument("--download", action="store_true", help="Download first result")
    search_parser.add_argument("--download-dir", default="./downloads", help="Download directory")

    # Random command
    random_parser = subparsers.add_parser("random", help="Get random photo(s)")
    random_parser.add_argument("-q", "--query", help="Search query for random photos")
    random_parser.add_argument("-o", "--orientation", choices=["landscape", "portrait", "squarish"], help="Orientation filter")
    random_parser.add_argument("-n", "--count", type=int, default=1, help="Number of photos (max 30)")
    random_parser.add_argument("--featured", action="store_true", help="Only featured photos")
    random_parser.add_argument("--download", action="store_true", help="Download photos")
    random_parser.add_argument("--download-dir", default="./downloads", help="Download directory")

    # Photo info command
    photo_parser = subparsers.add_parser("photo", help="Get photo by ID")
    photo_parser.add_argument("photo_id", help="Photo ID")
    photo_parser.add_argument("--download", action="store_true", help="Download photo")
    photo_parser.add_argument("--download-dir", default="./downloads", help="Download directory")

    # User command
    user_parser = subparsers.add_parser("user", help="Get user profile")
    user_parser.add_argument("username", help="Username")
    user_parser.add_argument("--photos", action="store_true", help="Also fetch user's photos")
    user_parser.add_argument("-n", "--per-page", type=int, default=10, help="Photos per page")

    # Collections command
    collections_parser = subparsers.add_parser("collections", help="List curated collections")
    collections_parser.add_argument("-p", "--page", type=int, default=1, help="Page number")
    collections_parser.add_argument("-n", "--per-page", type=int, default=10, help="Collections per page")

    # Collection photos command
    coll_photos_parser = subparsers.add_parser("collection-photos", help="Get photos from a collection")
    coll_photos_parser.add_argument("collection_id", help="Collection ID")
    coll_photos_parser.add_argument("-p", "--page", type=int, default=1, help="Page number")
    coll_photos_parser.add_argument("-n", "--per-page", type=int, default=10, help="Photos per page")
    coll_photos_parser.add_argument("--download", action="store_true", help="Download photos")
    coll_photos_parser.add_argument("--download-dir", default="./downloads", help="Download directory")

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return

    try:
        client = UnsplashClient()

        if args.command == "search":
            result = client.search_photos(
                query=args.query,
                page=args.page,
                per_page=args.per_page,
                orientation=args.orientation,
                color=args.color
            )
            print(f"Total results: {result['total']}")
            print(f"Total pages: {result['total_pages']}")
            print(f"---")
            for photo in result["results"]:
                print(format_photo_info(photo))

            if args.download and result["results"]:
                client.download_photo(result["results"][0], Path(args.download_dir))

        elif args.command == "random":
            photos = client.get_random_photo(
                query=args.query,
                orientation=args.orientation,
                featured=args.featured,
                count=args.count
            )
            for photo in photos:
                print(format_photo_info(photo))
                if args.download:
                    client.download_photo(photo, Path(args.download_dir))

        elif args.command == "photo":
            photo = client.get_photo(args.photo_id)
            print(format_photo_info(photo))
            if args.download:
                client.download_photo(photo, Path(args.download_dir))

        elif args.command == "user":
            user = client.get_user(args.username)
            print(f"Name: {user.get('name')}")
            print(f"Username: @{user.get('username')}")
            print(f"Bio: {user.get('bio')}")
            print(f"Location: {user.get('location')}")
            print(f"Photos: {user.get('total_photos')}")
            print(f"Likes: {user.get('total_likes')}")
            print(f"Collections: {user.get('total_collections')}")
            print(f"Profile: {user.get('links', {}).get('html')}")

            if args.photos:
                photos = client.get_user_photos(args.username, per_page=args.per_page)
                print(f"\n--- Recent Photos ---")
                for photo in photos:
                    print(format_photo_info(photo))

        elif args.command == "collections":
            collections = client.get_collections(page=args.page, per_page=args.per_page)
            for coll in collections:
                print(f"ID: {coll.get('id')}")
                print(f"Title: {coll.get('title')}")
                print(f"Description: {coll.get('description')}")
                print(f"Photos: {coll.get('total_photos')}")
                print(f"URL: {coll.get('links', {}).get('html')}")
                print(f"---")

        elif args.command == "collection-photos":
            photos = client.get_collection_photos(
                args.collection_id,
                page=args.page,
                per_page=args.per_page
            )
            for photo in photos:
                print(format_photo_info(photo))
                if args.download:
                    client.download_photo(photo, Path(args.download_dir))

    except requests.HTTPError as e:
        print(f"API Error: {e.response.status_code} - {e.response.text}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()