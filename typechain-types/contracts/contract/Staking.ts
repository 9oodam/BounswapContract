/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumberish,
  BytesLike,
  FunctionFragment,
  Result,
  Interface,
  EventFragment,
  AddressLike,
  ContractRunner,
  ContractMethod,
  Listener,
} from "ethers";
import type {
  TypedContractEvent,
  TypedDeferredTopicFilter,
  TypedEventLog,
  TypedLogDescription,
  TypedListener,
  TypedContractMethod,
} from "../../common";

export interface StakingInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "BNC"
      | "BNCPerBlock"
      | "BONUS_MULTIPLIER"
      | "addStakingPool"
      | "claimBNC"
      | "data"
      | "deposit"
      | "dev0Addr"
      | "dev0Percent"
      | "emergencyWithdraw"
      | "getMultiplier"
      | "lastBlockDevWithdraw"
      | "massUpdatePools"
      | "owner"
      | "pendingBNC"
      | "percentDec"
      | "poolInfo"
      | "poolLength"
      | "renounceOwnership"
      | "set"
      | "setDevAddress"
      | "setPercent"
      | "setStakingEndDays"
      | "stakingPercent"
      | "startBlock"
      | "totalAllocPoint"
      | "transferOwnership"
      | "updateBNCPerBlock"
      | "updatePool"
      | "userInfo"
      | "withdraw"
      | "withdrawDevFee"
  ): FunctionFragment;

  getEvent(
    nameOrSignatureOrTopic:
      | "ClaimBNC"
      | "Deposit"
      | "DistributeRewards"
      | "EmergencyWithdraw"
      | "OwnershipTransferred"
      | "SetDev0Address"
      | "SetPercent"
      | "UpdateBNCPerBlock"
      | "Withdraw"
  ): EventFragment;

  encodeFunctionData(functionFragment: "BNC", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "BNCPerBlock",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "BONUS_MULTIPLIER",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "addStakingPool",
    values: [BigNumberish, AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "claimBNC",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "data", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "deposit",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "dev0Addr", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "dev0Percent",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "emergencyWithdraw",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getMultiplier",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "lastBlockDevWithdraw",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "massUpdatePools",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "pendingBNC",
    values: [BigNumberish, AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "percentDec",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "poolInfo",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "poolLength",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "set",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setDevAddress",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setPercent",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setStakingEndDays",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "stakingPercent",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "startBlock",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "totalAllocPoint",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "updateBNCPerBlock",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "updatePool",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "userInfo",
    values: [BigNumberish, AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "withdraw",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "withdrawDevFee",
    values?: undefined
  ): string;

  decodeFunctionResult(functionFragment: "BNC", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "BNCPerBlock",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "BONUS_MULTIPLIER",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "addStakingPool",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "claimBNC", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "data", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "deposit", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "dev0Addr", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "dev0Percent",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "emergencyWithdraw",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getMultiplier",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "lastBlockDevWithdraw",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "massUpdatePools",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pendingBNC", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "percentDec", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "poolInfo", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "poolLength", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "set", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setDevAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setPercent", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setStakingEndDays",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "stakingPercent",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "startBlock", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "totalAllocPoint",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "updateBNCPerBlock",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "updatePool", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "userInfo", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "withdraw", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "withdrawDevFee",
    data: BytesLike
  ): Result;
}

export namespace ClaimBNCEvent {
  export type InputTuple = [
    user: AddressLike,
    pid: BigNumberish,
    amount: BigNumberish
  ];
  export type OutputTuple = [user: string, pid: bigint, amount: bigint];
  export interface OutputObject {
    user: string;
    pid: bigint;
    amount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace DepositEvent {
  export type InputTuple = [
    user: AddressLike,
    pid: BigNumberish,
    amount: BigNumberish
  ];
  export type OutputTuple = [user: string, pid: bigint, amount: bigint];
  export interface OutputObject {
    user: string;
    pid: bigint;
    amount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace DistributeRewardsEvent {
  export type InputTuple = [
    _pid: BigNumberish,
    pendingReward: BigNumberish,
    totalStaked: BigNumberish
  ];
  export type OutputTuple = [
    _pid: bigint,
    pendingReward: bigint,
    totalStaked: bigint
  ];
  export interface OutputObject {
    _pid: bigint;
    pendingReward: bigint;
    totalStaked: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace EmergencyWithdrawEvent {
  export type InputTuple = [
    user: AddressLike,
    pid: BigNumberish,
    amount: BigNumberish
  ];
  export type OutputTuple = [user: string, pid: bigint, amount: bigint];
  export interface OutputObject {
    user: string;
    pid: bigint;
    amount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace OwnershipTransferredEvent {
  export type InputTuple = [previousOwner: AddressLike, newOwner: AddressLike];
  export type OutputTuple = [previousOwner: string, newOwner: string];
  export interface OutputObject {
    previousOwner: string;
    newOwner: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace SetDev0AddressEvent {
  export type InputTuple = [dev0Addr: AddressLike];
  export type OutputTuple = [dev0Addr: string];
  export interface OutputObject {
    dev0Addr: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace SetPercentEvent {
  export type InputTuple = [
    stakingPercent: BigNumberish,
    dev0Percent: BigNumberish
  ];
  export type OutputTuple = [stakingPercent: bigint, dev0Percent: bigint];
  export interface OutputObject {
    stakingPercent: bigint;
    dev0Percent: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace UpdateBNCPerBlockEvent {
  export type InputTuple = [BNCPerBlock: BigNumberish];
  export type OutputTuple = [BNCPerBlock: bigint];
  export interface OutputObject {
    BNCPerBlock: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace WithdrawEvent {
  export type InputTuple = [
    user: AddressLike,
    pid: BigNumberish,
    amount: BigNumberish
  ];
  export type OutputTuple = [user: string, pid: bigint, amount: bigint];
  export interface OutputObject {
    user: string;
    pid: bigint;
    amount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface Staking extends BaseContract {
  connect(runner?: ContractRunner | null): Staking;
  waitForDeployment(): Promise<this>;

  interface: StakingInterface;

  queryFilter<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;
  queryFilter<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;

  on<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  on<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  once<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  once<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  listeners<TCEvent extends TypedContractEvent>(
    event: TCEvent
  ): Promise<Array<TypedListener<TCEvent>>>;
  listeners(eventName?: string): Promise<Array<Listener>>;
  removeAllListeners<TCEvent extends TypedContractEvent>(
    event?: TCEvent
  ): Promise<this>;

  BNC: TypedContractMethod<[], [string], "view">;

  BNCPerBlock: TypedContractMethod<[], [bigint], "view">;

  BONUS_MULTIPLIER: TypedContractMethod<[], [bigint], "view">;

  addStakingPool: TypedContractMethod<
    [_allocPoint: BigNumberish, _lpToken: AddressLike],
    [void],
    "nonpayable"
  >;

  claimBNC: TypedContractMethod<[_pid: BigNumberish], [void], "nonpayable">;

  data: TypedContractMethod<[], [string], "view">;

  deposit: TypedContractMethod<
    [_pid: BigNumberish, _amount: BigNumberish],
    [void],
    "nonpayable"
  >;

  dev0Addr: TypedContractMethod<[], [string], "view">;

  dev0Percent: TypedContractMethod<[], [bigint], "view">;

  emergencyWithdraw: TypedContractMethod<
    [_pid: BigNumberish],
    [void],
    "nonpayable"
  >;

  getMultiplier: TypedContractMethod<
    [_from: BigNumberish, _to: BigNumberish],
    [bigint],
    "view"
  >;

  lastBlockDevWithdraw: TypedContractMethod<[], [bigint], "view">;

  massUpdatePools: TypedContractMethod<[], [void], "nonpayable">;

  owner: TypedContractMethod<[], [string], "view">;

  pendingBNC: TypedContractMethod<
    [_pid: BigNumberish, _user: AddressLike],
    [bigint],
    "view"
  >;

  percentDec: TypedContractMethod<[], [bigint], "view">;

  poolInfo: TypedContractMethod<
    [arg0: BigNumberish],
    [
      [string, bigint, bigint, bigint, bigint] & {
        lpToken: string;
        allocPoint: bigint;
        lastRewardBlock: bigint;
        accBNCPerShare: bigint;
        stakingEndTime: bigint;
      }
    ],
    "view"
  >;

  poolLength: TypedContractMethod<[], [bigint], "view">;

  renounceOwnership: TypedContractMethod<[], [void], "nonpayable">;

  set: TypedContractMethod<
    [_pid: BigNumberish, _allocPoint: BigNumberish],
    [void],
    "nonpayable"
  >;

  setDevAddress: TypedContractMethod<
    [_dev0Addr: AddressLike],
    [void],
    "nonpayable"
  >;

  setPercent: TypedContractMethod<
    [_stakingPercent: BigNumberish, _dev0Percent: BigNumberish],
    [void],
    "nonpayable"
  >;

  setStakingEndDays: TypedContractMethod<
    [_pid: BigNumberish, _days: BigNumberish],
    [void],
    "nonpayable"
  >;

  stakingPercent: TypedContractMethod<[], [bigint], "view">;

  startBlock: TypedContractMethod<[], [bigint], "view">;

  totalAllocPoint: TypedContractMethod<[], [bigint], "view">;

  transferOwnership: TypedContractMethod<
    [newOwner: AddressLike],
    [void],
    "nonpayable"
  >;

  updateBNCPerBlock: TypedContractMethod<
    [newAmount: BigNumberish],
    [void],
    "nonpayable"
  >;

  updatePool: TypedContractMethod<[_pid: BigNumberish], [void], "nonpayable">;

  userInfo: TypedContractMethod<
    [arg0: BigNumberish, arg1: AddressLike],
    [
      [bigint, bigint, bigint] & {
        amount: bigint;
        exactRewardCal: bigint;
        pendingReward: bigint;
      }
    ],
    "view"
  >;

  withdraw: TypedContractMethod<
    [_pid: BigNumberish, _amount: BigNumberish],
    [void],
    "nonpayable"
  >;

  withdrawDevFee: TypedContractMethod<[], [void], "nonpayable">;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "BNC"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "BNCPerBlock"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "BONUS_MULTIPLIER"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "addStakingPool"
  ): TypedContractMethod<
    [_allocPoint: BigNumberish, _lpToken: AddressLike],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "claimBNC"
  ): TypedContractMethod<[_pid: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "data"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "deposit"
  ): TypedContractMethod<
    [_pid: BigNumberish, _amount: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "dev0Addr"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "dev0Percent"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "emergencyWithdraw"
  ): TypedContractMethod<[_pid: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "getMultiplier"
  ): TypedContractMethod<
    [_from: BigNumberish, _to: BigNumberish],
    [bigint],
    "view"
  >;
  getFunction(
    nameOrSignature: "lastBlockDevWithdraw"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "massUpdatePools"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "owner"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "pendingBNC"
  ): TypedContractMethod<
    [_pid: BigNumberish, _user: AddressLike],
    [bigint],
    "view"
  >;
  getFunction(
    nameOrSignature: "percentDec"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "poolInfo"
  ): TypedContractMethod<
    [arg0: BigNumberish],
    [
      [string, bigint, bigint, bigint, bigint] & {
        lpToken: string;
        allocPoint: bigint;
        lastRewardBlock: bigint;
        accBNCPerShare: bigint;
        stakingEndTime: bigint;
      }
    ],
    "view"
  >;
  getFunction(
    nameOrSignature: "poolLength"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "renounceOwnership"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "set"
  ): TypedContractMethod<
    [_pid: BigNumberish, _allocPoint: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setDevAddress"
  ): TypedContractMethod<[_dev0Addr: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setPercent"
  ): TypedContractMethod<
    [_stakingPercent: BigNumberish, _dev0Percent: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setStakingEndDays"
  ): TypedContractMethod<
    [_pid: BigNumberish, _days: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "stakingPercent"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "startBlock"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "totalAllocPoint"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "transferOwnership"
  ): TypedContractMethod<[newOwner: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "updateBNCPerBlock"
  ): TypedContractMethod<[newAmount: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "updatePool"
  ): TypedContractMethod<[_pid: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "userInfo"
  ): TypedContractMethod<
    [arg0: BigNumberish, arg1: AddressLike],
    [
      [bigint, bigint, bigint] & {
        amount: bigint;
        exactRewardCal: bigint;
        pendingReward: bigint;
      }
    ],
    "view"
  >;
  getFunction(
    nameOrSignature: "withdraw"
  ): TypedContractMethod<
    [_pid: BigNumberish, _amount: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "withdrawDevFee"
  ): TypedContractMethod<[], [void], "nonpayable">;

  getEvent(
    key: "ClaimBNC"
  ): TypedContractEvent<
    ClaimBNCEvent.InputTuple,
    ClaimBNCEvent.OutputTuple,
    ClaimBNCEvent.OutputObject
  >;
  getEvent(
    key: "Deposit"
  ): TypedContractEvent<
    DepositEvent.InputTuple,
    DepositEvent.OutputTuple,
    DepositEvent.OutputObject
  >;
  getEvent(
    key: "DistributeRewards"
  ): TypedContractEvent<
    DistributeRewardsEvent.InputTuple,
    DistributeRewardsEvent.OutputTuple,
    DistributeRewardsEvent.OutputObject
  >;
  getEvent(
    key: "EmergencyWithdraw"
  ): TypedContractEvent<
    EmergencyWithdrawEvent.InputTuple,
    EmergencyWithdrawEvent.OutputTuple,
    EmergencyWithdrawEvent.OutputObject
  >;
  getEvent(
    key: "OwnershipTransferred"
  ): TypedContractEvent<
    OwnershipTransferredEvent.InputTuple,
    OwnershipTransferredEvent.OutputTuple,
    OwnershipTransferredEvent.OutputObject
  >;
  getEvent(
    key: "SetDev0Address"
  ): TypedContractEvent<
    SetDev0AddressEvent.InputTuple,
    SetDev0AddressEvent.OutputTuple,
    SetDev0AddressEvent.OutputObject
  >;
  getEvent(
    key: "SetPercent"
  ): TypedContractEvent<
    SetPercentEvent.InputTuple,
    SetPercentEvent.OutputTuple,
    SetPercentEvent.OutputObject
  >;
  getEvent(
    key: "UpdateBNCPerBlock"
  ): TypedContractEvent<
    UpdateBNCPerBlockEvent.InputTuple,
    UpdateBNCPerBlockEvent.OutputTuple,
    UpdateBNCPerBlockEvent.OutputObject
  >;
  getEvent(
    key: "Withdraw"
  ): TypedContractEvent<
    WithdrawEvent.InputTuple,
    WithdrawEvent.OutputTuple,
    WithdrawEvent.OutputObject
  >;

  filters: {
    "ClaimBNC(address,uint256,uint256)": TypedContractEvent<
      ClaimBNCEvent.InputTuple,
      ClaimBNCEvent.OutputTuple,
      ClaimBNCEvent.OutputObject
    >;
    ClaimBNC: TypedContractEvent<
      ClaimBNCEvent.InputTuple,
      ClaimBNCEvent.OutputTuple,
      ClaimBNCEvent.OutputObject
    >;

    "Deposit(address,uint256,uint256)": TypedContractEvent<
      DepositEvent.InputTuple,
      DepositEvent.OutputTuple,
      DepositEvent.OutputObject
    >;
    Deposit: TypedContractEvent<
      DepositEvent.InputTuple,
      DepositEvent.OutputTuple,
      DepositEvent.OutputObject
    >;

    "DistributeRewards(uint256,uint256,uint256)": TypedContractEvent<
      DistributeRewardsEvent.InputTuple,
      DistributeRewardsEvent.OutputTuple,
      DistributeRewardsEvent.OutputObject
    >;
    DistributeRewards: TypedContractEvent<
      DistributeRewardsEvent.InputTuple,
      DistributeRewardsEvent.OutputTuple,
      DistributeRewardsEvent.OutputObject
    >;

    "EmergencyWithdraw(address,uint256,uint256)": TypedContractEvent<
      EmergencyWithdrawEvent.InputTuple,
      EmergencyWithdrawEvent.OutputTuple,
      EmergencyWithdrawEvent.OutputObject
    >;
    EmergencyWithdraw: TypedContractEvent<
      EmergencyWithdrawEvent.InputTuple,
      EmergencyWithdrawEvent.OutputTuple,
      EmergencyWithdrawEvent.OutputObject
    >;

    "OwnershipTransferred(address,address)": TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;
    OwnershipTransferred: TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;

    "SetDev0Address(address)": TypedContractEvent<
      SetDev0AddressEvent.InputTuple,
      SetDev0AddressEvent.OutputTuple,
      SetDev0AddressEvent.OutputObject
    >;
    SetDev0Address: TypedContractEvent<
      SetDev0AddressEvent.InputTuple,
      SetDev0AddressEvent.OutputTuple,
      SetDev0AddressEvent.OutputObject
    >;

    "SetPercent(uint256,uint256)": TypedContractEvent<
      SetPercentEvent.InputTuple,
      SetPercentEvent.OutputTuple,
      SetPercentEvent.OutputObject
    >;
    SetPercent: TypedContractEvent<
      SetPercentEvent.InputTuple,
      SetPercentEvent.OutputTuple,
      SetPercentEvent.OutputObject
    >;

    "UpdateBNCPerBlock(uint256)": TypedContractEvent<
      UpdateBNCPerBlockEvent.InputTuple,
      UpdateBNCPerBlockEvent.OutputTuple,
      UpdateBNCPerBlockEvent.OutputObject
    >;
    UpdateBNCPerBlock: TypedContractEvent<
      UpdateBNCPerBlockEvent.InputTuple,
      UpdateBNCPerBlockEvent.OutputTuple,
      UpdateBNCPerBlockEvent.OutputObject
    >;

    "Withdraw(address,uint256,uint256)": TypedContractEvent<
      WithdrawEvent.InputTuple,
      WithdrawEvent.OutputTuple,
      WithdrawEvent.OutputObject
    >;
    Withdraw: TypedContractEvent<
      WithdrawEvent.InputTuple,
      WithdrawEvent.OutputTuple,
      WithdrawEvent.OutputObject
    >;
  };
}