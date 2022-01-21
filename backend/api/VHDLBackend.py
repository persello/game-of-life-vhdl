import time
from ptyprocess import PtyProcessUnicode
from typing import Tuple, List


class VHDLBackend:
    """
    VHDL backend management class.
    """

    def __init__(self, process: PtyProcessUnicode):
        self.process = process

        # Wait for the backend to start.
        time.sleep(1)

        # Clear and print the output until the backend prints "READY".
        while True:
            line = self.process.readline()
            print(f"VHDLBackend: {line.strip()}")
            if line.startswith("READY"):
                break

        self.board_size = self.get_board_size()

    def __del__(self):
        self.process.close()

    def get_board_size(self) -> Tuple[int, int]:
        """
        Returns the board size as a tuple of ints.
        """

        # Send an 'x' to the process to get the horizontal board size.
        self.process.write("x\n")

        # Get the last output line.
        assert(self.process.readline().startswith("x"))
        x = int(self.process.readline().strip())

        # Send an 'y' to the process to get the vertical board size.
        self.process.write("y\n")

        # Get the last output line.
        assert(self.process.readline().startswith("y"))
        y = int(self.process.readline().strip())

        return x, y

    def get_next_board_state(self) -> List[List[bool]]:
        """
        Returns the current board state as a list of lists of bools.
        """

        # Send an 's' to the process to get the board state.
        self.process.write("s\n")

        # Empty state.
        board_state = []

        # Check command confirmation.
        assert self.process.readline().startswith("s")
        
        # Read the board state.
        for _ in range(self.board_size[1]):
            line = self.process.readline().strip()
            board_state.append(list(map(lambda x: x == "1", line)))

        return board_state

    def set_board_state(self, board_state: List[List[bool]]):
        """
        Sets the current board state to the given board state.
        """

        # Build the command string.
        command = "l\n"
        for line in board_state:
            command += "".join(map(lambda x: "1" if x else "0", line)) + "\n"

        self.process.write(command)
