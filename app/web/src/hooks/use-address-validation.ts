/**
 * Hook to validate Polkadot SS58 addresses
 */

import { useMemo } from 'react';
import { encodeAddress, decodeAddress } from '@polkadot/util-crypto';

export function useAddressValidation(address: string) {
  return useMemo(() => {
    const value = address?.trim();
    if (!value) return false;
    try {
      const decoded = decodeAddress(value);
      encodeAddress(decoded);
      return true;
    } catch {
      return false;
    }
  }, [address]);
}


