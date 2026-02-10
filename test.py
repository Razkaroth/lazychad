#!/usr/bin/env python3
"""
Blink.cmp Testing Playground
=============================

This file is designed to test various blink.cmp features:
1. Auto-brackets - Type function names and see automatic bracket completion
2. Documentation - Hover over completions to see docs
3. Signature help - Type function calls to see parameter hints
4. LSP completions - Import statements and method calls
5. Ghost text - See inline completion suggestions
"""

import os
import sys
import json
from pathlib import Path
from typing import List, Dict, Optional


# Test 1: Auto-brackets
# Try typing: def my_function
def calculate_sum(a: int, b: int) -> int:
    """Calculate the sum of two numbers."""
    return a + b


def my_function():
    """Return the current date and time formatted for the Mexican Spanish locale."""
    from datetime import datetime
    import locale

    original_locale = locale.setlocale(locale.LC_TIME)
    for locale_name in ("es_MX.UTF-8", "es_MX", "es_ES.UTF-8"):
        try:
            locale.setlocale(locale.LC_TIME, locale_name)
            break
        except locale.Error:
            continue

    formatted = datetime.now().strftime("%c")
    locale.setlocale(locale.LC_TIME, original_locale)
    return formatted


def salutation(name: str) -> str:
    return f


# Test 2: Documentation
# Try hovering over: calculate_sum
# Try hovering over: my_function
#
#


# Test 2: Dictionary/Object completions
# Try typing: user["  or  config.
user = {"name": "John", "age": 30, "email": "john@example.com"}

config = {
    "debug": True,
    "database": {"host": "localhost", "port": 5432},
    "features": ["auth", "api", "cache"],
}


# Test 3: Method completions and signature help
# Try typing: text.  (see methods)
# Try typing: text.replace(  (see signature help)
text = "Hello World"


# Test 4: List/Array operations
# Try typing: numbers.  (see list methods)
numbers = [1, 2, 3, 4, 5]
words = ["apple", "banana", "cherry"]
synonims = ["apple", "banana", "cherry"]
antonyms = ["orange", "grape", "lemon"]


# Test 5: Path completions
# Try typing: Path("/  (should show path completions)
def read_file(filepath: str) -> str:
    """Read a file and return its contents."""
    with open(filepath, "r") as f:
        return f.read()


# Test 6: Class definitions and self completions
# Try typing: self.  inside methods
class Calculator:
    """A simple calculator class for testing completions."""

    def __init__(self, initial_value: int = 0):
        self.value = initial_value
        self.history = []
        self.precision = 2

    def add(self, x: int) -> int:
        """Add a number to the current value."""
        self.value += x
        self.history.append(f"add {x}")
        return self.value

    def subtract(self, x: int) -> int:
        """Subtract a number from the current value."""
        self.value -= x
        self.history.append(f"subtract {x}")
        return self.value

    def get_history(self) -> List[str]:
        """Return the calculation history."""
        return self.history


# Test 7: Import completions
# Try typing: from pathlib import
# Try typing: import


# Test 8: Function with multiple parameters (signature help)
# Try typing: process_data(  (should show all parameters)
def process_data(
    input_file: str,
    output_file: str,
    mode: str = "read",
    encoding: str = "utf-8",
    verbose: bool = False,
) -> Dict[str, any]:
    """
    Process data from input file to output file.

    Args:
        input_file: Path to the input file
        output_file: Path to the output file
        mode: Processing mode (read/write/append)
        encoding: File encoding to use
        verbose: Enable verbose output

    Returns:
        Dictionary with processing results
    """
    return {"status": "success", "lines": 0}


# Test 9: Nested completions
# Try typing: result["data"]["user"]["
def get_nested_data() -> Dict:
    """Return nested dictionary structure."""
    return {
        "data": {
            "user": {"id": 1, "name": "Alice", "roles": ["admin", "user"]},
            "settings": {"theme": "dark", "notifications": True},
        },
        "meta": {"timestamp": "2024-01-01", "version": "1.0"},
    }


# Test 10: Try-except blocks (snippet expansion)
# Type: try  (should offer try-except snippet)


# Test 11: For loops (snippet expansion)
# Type: for  (should offer for loop snippet)


# Test 12: Lambda functions
# Try typing: sorted(numbers, key=lambda
transform = lambda x: x * 2
filter_even = lambda x: x % 2 == 0


# Playground area - Type your code below:
# ==========================================

if __name__ == "__main__":
    # Start testing here!
    # Try these exercises:
    #
    # 1. Create a Calculator instance: calc = Calculator(
    # 2. Call methods: calc.add(
    # 3. Access attributes: calc.
    # 4. Work with strings: text.
    # 5. Use Path: p = Path(
    # 6. Dict access: user[
    # 7. List methods: numbers.
    # 8. Import something: from pathlib import

    pass
