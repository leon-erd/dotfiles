def stdout_assert(stdout: str, expected: str):
    if stdout != expected:
        raise AssertionError(f'\nExpected output: {expected}'
                             f'Actual output: {stdout}')