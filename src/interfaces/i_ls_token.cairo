use starknet::ContractAddress;

#[starknet::interface]
trait ILSToken<TContractState> {
    fn asset(self: @TContractState) -> ContractAddress;
    fn total_assets(self: @TContractState) -> u256;
    fn convert_to_shares(self: @TContractState, assets: u256) -> u256;
    fn convert_to_assets(self: @TContractState, shares: u256) -> u256;
    fn max_deposit(self: @TContractState, receiver: ContractAddress) -> u256;
    fn preview_deposit(self: @TContractState, assets: u256) -> u256;
    fn deposit(ref self: TContractState, assets: u256, receiver: ContractAddress) -> u256;
    fn max_mint(self: @TContractState, receiver: ContractAddress) -> u256;
    fn preview_mint(self: @TContractState, assets: u256) -> u256;
    fn mint(ref self: TContractState, assets: u256, receiver: ContractAddress) -> u256;
    fn max_withdraw(self: @TContractState, owner: ContractAddress) -> u256;
    fn preview_withdraw(self: @TContractState, assets: u256) -> u256;
    fn withdraw(ref self: TContractState, assets: u256, receiver: ContractAddress, owner: ContractAddress) -> u256;
    fn max_redeem(self: @TContractState, owner: ContractAddress) -> u256;
    fn preview_redeem(self: @TContractState, shares: u256) -> u256;
    fn redeem(ref self: TContractState, shares: u256, receiver: ContractAddress, owner: ContractAddress) -> u256;
    fn rebase(ref self: TContractState, new_total_assets: u256);
    fn burn(ref self: TContractState, share: u256, caller: ContractAddress);
    fn shares_per_asset(self: @TContractState) -> u256;

    // ERC20 functions
    // fn total_supply(self: @TContractState) -> u256;
    // fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    // fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    // fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    // fn transfer_from(ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    // fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}