import pytest
import os
from wrapper.setup import ctxConfigSetup, VALIDATE_PROG
from sibd_cli import validateBatch


# Includes tests for the python wrapper

def test_setup():
    ctxDict = ctxConfigSetup("work/sibd.toml", "cairo/src", True)
    assert "work" in ctxDict, "Work directory does not exist in config."
    assert "dir" in ctxDict["work"], "Work directory does not exist in config."
    assert os.path.exists(ctxDict["work"]["dir"]
                          ), "Work directory does not exist."

    # Compiler creates a file even when compilation fails!
    # We will catch that when running the cli in next test.
    assert os.path.exists(
        ctxDict["work"]["dir"] + VALIDATE_PROG), "Compiler was not called."


def test_input():
    pass
