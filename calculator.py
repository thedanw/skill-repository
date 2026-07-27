def add(x, y):
    """Add two numbers."""
    return x + y

def subtract(x, y):
    """Subtract two numbers."""
    return x - y

def multiply(x, y):
    """Multiply two numbers."""
    return x * y

def divide(x, y):
    """Divide two numbers."""
    if y == 0:
        raise ValueError("Cannot divide by zero!")
    return x / y

def calculator():
    """Simple calculator interface."""
    print("Simple Calculator")
    print("Select operation:")
    print("1. Add")
    print("2. Subtract")
    print("3. Multiply")
    print("4. Divide")
    
    while True:
        try:
            choice = input("\nEnter choice (1/2/3/4) or 'q' to quit: ")
            
            if choice == 'q':
                print("Exiting calculator. Goodbye!")
                break
            
            if choice in ['1', '2', '3', '4']:
                num1 = float(input("Enter first number: "))
                num2 = float(input("Enter second number: "))
                
                if choice == '1':
                    result = add(num1, num2)
                    print(f"{num1} + {num2} = {result}")
                elif choice == '2':
                    result = subtract(num1, num2)
                    print(f"{num1} - {num2} = {result}")
                elif choice == '3':
                    result = multiply(num1, num2)
                    print(f"{num1} * {num2} = {result}")
                elif choice == '4':
                    try:
                        result = divide(num1, num2)
                        print(f"{num1} / {num2} = {result}")
                    except ValueError as e:
                        print(f"Error: {e}")
            else:
                print("Invalid input. Please enter a valid choice (1/2/3/4) or 'q' to quit.")
        except ValueError:
            print("Invalid input. Please enter numeric values.")
        except KeyboardInterrupt:
            print("\nExiting calculator. Goodbye!")
            break

if __name__ == "__main__":
    calculator()