from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from ptyprocess import PtyProcessUnicode
from typing import Tuple, List
from .VHDLBackend import VHDLBackend

app = FastAPI()

# GHDL simulation process started by `make`.
process = PtyProcessUnicode.spawn(["make"], echo=False)
backend = VHDLBackend(process)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get(
    "/board-size",
    response_model=Tuple[int, int],
    summary="Get the board size.",
    description="Returns the board size as a tuple of ints.",
    name="Board Size",
    operation_id="board_size",
)
async def board_size() -> Tuple[int, int]:
    return backend.get_board_size()


@app.get(
    "/state",
    response_model=List[List[bool]],
    summary="Get the current board state.",
    description="Returns the current board state as a list of lists of bools.",
    name="Get Board State",
    operation_id="get_board_state",
)
async def get_state() -> List[List[bool]]:
    return backend.get_board_state()


@app.post(
    "/state",
    response_model=List[List[bool]],
    summary="Set the current board state.",
    description="Sets the current board state as a list of lists of bools.",
    name="Set Board State",
    operation_id="set_board_state",
)
async def set_state(state: List[List[bool]]) -> List[List[bool]]:
    backend.set_board_state(state)
    return state

@app.post(
    "/step",
    response_model=List[List[bool]],
    summary="Step the simulation.",
    description="Steps the simulation.",
    name="Step",
    operation_id="step",
)
async def step() -> List[List[bool]]:
    backend.step()
    return backend.get_board_state()