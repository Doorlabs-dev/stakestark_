use starknet::{ContractAddress, ClassHash};
// Fee Strategy enum for the Strategy pattern
#[derive(Drop, Copy, Serde, PartialEq, starknet::Store)]
enum FeeStrategy {
    Flat: u16,
    Tiered: (u16, u16, u256), // (low_fee, high_fee, threshold)
}

#[derive(Drop, Serde, starknet::Store)]
struct WithdrawalRequest {
    assets: u256,
    withdrawal_time: u64,
}

mod Events{
    use super::ContractAddress;

    #[derive(Drop, starknet::Event)]
    struct Deposit {
        #[key]
        user: ContractAddress,
        amount: u256,
        shares: u256
    }

    #[derive(Drop, starknet::Event)]
    struct DelegatorWithdrew {
        id: u8,
        delegator: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalRequested {
        user: ContractAddress,
        request_id: u32,
        shares: u256,
        assets: u256,
        withdrawal_time: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct Withdraw {
        user: ContractAddress,
        total_assets: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct RewardDistributed {
        total_reward: u256,
        platform_fee_amount: u256,
        distributed_reward: u256
    }

    #[derive(Drop, starknet::Event)]
    struct DelegatorAdded {
        #[key]
        delegator: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct DelegatorStatusChanged {
        #[key]
        delegator: ContractAddress,
        status: bool,
        available_time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct FeeStrategyChanged {
        new_strategy: super::FeeStrategy,
    }

    #[derive(Drop, starknet::Event)]
    struct UnavailabilityPeriodChanged {
        old_period: u64,
        new_period: u64
    }

    #[derive(Drop, starknet::Event)]
    struct DepositAddedInQueue {
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawalAddedInQueue {
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct BatchProcessed {
        net_deposit_amount: u256,
        net_withdrawal_amount: u256,
        timestamp: u64,
    }

}

#[starknet::interface]
trait ILiquidStaking<TContractState> {
    fn deposit(ref self: TContractState, amount: u256) -> u256;
    fn request_withdrawal(ref self: TContractState, shares: u256);
    fn withdraw(ref self: TContractState);
    fn process_batch(ref self: TContractState);

    fn set_fee_strategy(ref self: TContractState, new_strategy: FeeStrategy);
    fn set_platform_fee_recipient(ref self: TContractState, recipient: ContractAddress);
    fn pause(ref self: TContractState);
    fn unpause(ref self: TContractState);

    fn set_unavailability_period(ref self: TContractState, new_period: u64);

    fn upgrade(ref self: TContractState, new_class_hash: ClassHash);
    fn upgrade_delegator(ref self: TContractState, new_class_hash: ClassHash);
    fn upgrade_lst(ref self: TContractState, new_class_hash: ClassHash);
}

#[starknet::interface] 
trait ILiquidStakingView<TContractState> {
    fn get_lst_address(self: @TContractState) -> ContractAddress;
    fn get_delegators_address(self: @TContractState) -> Array<ContractAddress>;
    fn get_fee_strategy(self: @TContractState) -> FeeStrategy;
    fn get_platform_fee_recipient(self: @TContractState) -> ContractAddress;
    fn get_withdrawable_amount(self: @TContractState, user: ContractAddress) -> u256;
    fn get_all_withdrawal_requests(
        self: @TContractState, user: ContractAddress
    ) -> Array<WithdrawalRequest>;
    fn get_available_withdrawal_requests(self: @TContractState, user: ContractAddress) -> Array<(u32, WithdrawalRequest)>;
    fn get_unavailability_period(self: @TContractState) -> u64;
    fn get_pending_deposits(self: @TContractState) -> u256;
    fn get_pending_withdrawals(self: @TContractState) -> u256 ;
    fn get_last_processing_time(self: @TContractState) -> u64;
}
