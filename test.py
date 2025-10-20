#!/usr/bin/env python3
"""Simple CLI calculator.

- Evaluates arithmetic expressions safely using ast (no eval/exec of arbitrary code).
- Supports -e/--expr for one-off evaluation.
- Starts an interactive REPL when no expression is given.
- Optional --math to enable math functions (sin, cos, sqrt, etc.).
"""

import ast
import operator
import argparse
import readline
import math
import sys

# Allowed binary operators
_BIN_OPS = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
    ast.FloorDiv: operator.floordiv,
    ast.Mod: operator.mod,
    ast.Pow: operator.pow,
}

# Allowed unary operators
_UNARY_OPS = {
    ast.UAdd: operator.pos,
    ast.USub: operator.neg,
}

# Whitelisted math functions
_MATH_FUNCS = {
    "sin": math.sin,
    "cos": math.cos,
    "tan": math.tan,
    "sqrt": math.sqrt,
    "log": math.log,
    "log10": math.log10,
    "exp": math.exp,
    "pow": math.pow,
    "abs": abs,
    "round": round,
}

# Constants available
_CONSTS = {
    "pi": math.pi,
    "e": math.e,
    # Fundamental constants (SI)
    "c": 299_792_458.0,  # speed of light in vacuum (m / s)
    "G": 6.67430e-11,  # gravitational constant (m^3 / kg / s^2)
    "h": 6.62607015e-34,  # Planck constant (J s)
    "hbar": 1.054571817e-34,  # reduced Planck constant (J s)
    "k": 1.380649e-23,  # Boltzmann constant (J / K)
    "NA": 6.02214076e23,  # Avogadro constant (1 / mol)
    "R": 8.31446261815324,  # gas constant (J / (mol K))
    "eps0": 8.8541878128e-12,  # vacuum permittivity (F / m)
    "mu0": 1.25663706212e-6,  # vacuum permeability (N / A^2)
    # Particle and mass constants
    "me": 9.1093837015e-31,  # electron mass (kg)
    "mp": 1.67262192369e-27,  # proton mass (kg)
    "amu": 1.66053906660e-27,  # atomic mass unit (kg)
    # Common terrestrial constant
    "g": 9.80665,  # standard gravity (m / s^2)
}


def _eval_node(node, allow_funcs=False):
    """Recursively evaluate an AST node returning a number.

    Raises ValueError for unsupported nodes.
    """
    if isinstance(node, ast.Expression):
        return _eval_node(node.body, allow_funcs)

    if isinstance(node, ast.BinOp):
        op_type = type(node.op)
        if op_type not in _BIN_OPS:
            raise ValueError(f"Unsupported binary operator: {op_type}")
        left = _eval_node(node.left, allow_funcs)
        right = _eval_node(node.right, allow_funcs)
        return _BIN_OPS[op_type](left, right)

    if isinstance(node, ast.UnaryOp):
        op_type = type(node.op)
        if op_type not in _UNARY_OPS:
            raise ValueError(f"Unsupported unary operator: {op_type}")
        operand = _eval_node(node.operand, allow_funcs)
        return _UNARY_OPS[op_type](operand)

    # Numbers (ast.Constant for py3.8+)
    if isinstance(node, ast.Constant):
        if isinstance(node.value, (int, float)):
            return node.value
        raise ValueError(f"Unsupported constant: {node.value}")

    # Older AST nodes for numbers
    if hasattr(ast, "Num") and isinstance(node, ast.Num):
        return node.n

    # Names: allow constants like pi, e
    if isinstance(node, ast.Name):
        idn = node.id
        if idn in _CONSTS:
            return _CONSTS[idn]
        raise ValueError(f"Unknown identifier: {idn}")

    # Function calls: allowed only when allow_funcs is True
    if isinstance(node, ast.Call):
        if not allow_funcs:
            raise ValueError(
                "Function calls are disabled. Use --math to enable math functions."
            )
        # Only simple name calls like sin(x)
        if not isinstance(node.func, ast.Name):
            raise ValueError("Only direct function calls are allowed")
        func_name = node.func.id
        if func_name not in _MATH_FUNCS:
            raise ValueError(f"Function '{func_name}' is not allowed")
        func = _MATH_FUNCS[func_name]
        # No keyword args
        if node.keywords:
            raise ValueError("Keyword arguments are not allowed in function calls")
        args = [_eval_node(a, allow_funcs) for a in node.args]
        return func(*args)

    raise ValueError(f"Unsupported expression: {ast.dump(node)}")


def evaluate(expr: str, allow_funcs: bool = False):
    """Parse and evaluate an expression string safely."""
    try:
        parsed = ast.parse(expr, mode="eval")
    except SyntaxError as e:
        raise ValueError(f"Syntax error: {e}")
    return _eval_node(parsed, allow_funcs)


def repl(allow_funcs: bool):
    print("Simple CLI Calculator. Type 'exit' or 'quit' to leave.")
    try:
        while True:
            try:
                s = input("calc> ").strip()
            except (EOFError, KeyboardInterrupt):
                print()
                break
            if not s:
                continue
            if s.lower() in ("exit", "quit", "q"):
                break
            try:
                result = evaluate(s, allow_funcs)
                print(result)
            except Exception as e:
                print(f"Error: {e}")
    except KeyboardInterrupt:
        print()


def build_parser():
    p = argparse.ArgumentParser(description="Simple safe CLI calculator")
    p.add_argument("-e", "--expr", help="Expression to evaluate")
    p.add_argument(
        "--math",
        action="store_true",
        help="Enable math functions (sin, cos, sqrt, etc.)",
    )
    p.add_argument(
        "--list-consts",
        action="store_true",
        help="List available constants and exit",
    )
    p.add_argument("--version", action="version", version="calc 0.1")
    return p


def main():
    parser = build_parser()
    args = parser.parse_args()
    allow_funcs = bool(args.math)

    # If requested, list available constants and exit
    if getattr(args, "list_consts", False):
        for name in sorted(_CONSTS):
            print(f"{name} = {_CONSTS[name]}")
        return

    if args.expr:
        try:
            out = evaluate(args.expr, allow_funcs)
            print(out)
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(1)
        return

    # Interactive REPL
    # Enable simple readline history
    try:
        readline.read_history_file()
    except Exception:
        pass
    repl(allow_funcs)
    try:
        readline.write_history_file()
    except Exception:
        pass


if __name__ == "__main__":
    main()
