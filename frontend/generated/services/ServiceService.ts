/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { CancelablePromise } from '../core/CancelablePromise';
import { request as __request } from '../core/request';

export class ServiceService {

    /**
     * Board Size
     * @returns any Successful Response
     * @throws ApiError
     */
    public static boardSizeBoardSizeGet(): CancelablePromise<any> {
        return __request({
            method: 'GET',
            path: `/board-size`,
        });
    }

    /**
     * Next State
     * @returns any Successful Response
     * @throws ApiError
     */
    public static nextStateStateGet(): CancelablePromise<any> {
        return __request({
            method: 'GET',
            path: `/state`,
        });
    }

    /**
     * Set State
     * @param requestBody
     * @returns any Successful Response
     * @throws ApiError
     */
    public static setStateStatePost(
        requestBody: Array<Array<boolean>>,
    ): CancelablePromise<any> {
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

}