/**
 * @axvn-hoding/sdk
 * Core AXVN Network SDK — re-exports the full @axvn-hoding/common runtime
 * (configuration, constants, errors, logger, types, utils, websocket engine)
 * so consumers only need a single dependency.
 */

export * from '@axvn-hoding/common';

export const PACKAGE_NAME = '@axvn-hoding/sdk';
export const VERSION = '1.0.0-alpha.1';
