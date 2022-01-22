/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { CancelablePromise } from '../core/CancelablePromise';
import { request as __request } from '../core/request';

export class ServiceVHDLBackend {

    /**
     * Get the board size.
     * Returns the board size as a tuple of ints.
     * @returns any Successful Response
     * @throws ApiError
     */
    public static boardSize(): CancelablePromise<Array<any>> {
        return __request({
            method: 'GET',
            path: `/board-size`,
        });
    }

    /**
     * Get the current board state.
     * Returns the current board state as a list of lists of bools.
     * @returns boolean Successful Response
     * @throws ApiError
     */
    public static getBoardState(): CancelablePromise<Array<Array<boolean>>> {
        return __request({
            method: 'GET',
            path: `/state`,
        });
    }

    /**
     * Set the current board state.
     * Sets the current board state as a list of lists of bools.
     * @param requestBody
     * @returns boolean Successful Response
     * @throws ApiError
     */
    public static setBoardState(
        requestBody: Array<Array<boolean>>,
    ): CancelablePromise<Array<Array<boolean>>> {
        return __request({
            method: 'POST',
            path: `/state`,
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }

    /**
     * Step the simulation.
     * Steps the simulation.
     * @returns boolean Successful Response
     * @throws ApiError
     */
    public static step(): CancelablePromise<Array<Array<boolean>>> {
        return __request({
            method: 'POST',
            path: `/step`,
        });
    }

}