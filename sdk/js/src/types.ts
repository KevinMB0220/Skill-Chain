/**
 * Type definitions for SkillChain SDK
 */

import type { ApiPromise } from '@polkadot/api';
import type { ContractPromise } from '@polkadot/api-contract';

/**
 * Claim types supported by SkillChain protocol
 */
export enum ClaimType {
  JobCompleted = 'JobCompleted',
  HackathonWin = 'HackathonWin',
  RepoContribution = 'RepoContribution',
  SkillEndorsement = 'SkillEndorsement',
  Other = 'Other',
}

/**
 * Profile data structure
 */
export interface Profile {
  owner: string;
  metadataUri: string;
  createdAt: number;
}

/**
 * Claim data structure
 */
export interface Claim {
  id: number;
  issuer: string;
  receiver: string;
  claimType: ClaimType;
  proofHash: string;
  approved: boolean;
  timestamp: number;
}

/**
 * Configuration for SkillChain client
 */
export interface SkillChainConfig {
  /** Polkadot API instance */
  api: ApiPromise;
  /** Contract address */
  contractAddress: string;
  /** Contract ABI metadata */
  abi: any;
}

/**
 * Options for creating a profile
 */
export interface CreateProfileOptions {
  metadataUri: string;
}

/**
 * Options for adding a claim
 */
export interface AddClaimOptions {
  receiver: string;
  claimType: ClaimType;
  proofHash: string;
}

/**
 * Options for approving a claim
 */
export interface ApproveClaimOptions {
  claimId: number;
}

/**
 * Result of a transaction
 */
export interface TransactionResult {
  success: boolean;
  txHash?: string;
  error?: string;
}

