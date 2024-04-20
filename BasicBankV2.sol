// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract BasicBankV2 {
    /// sử dụng để lưu trữ số dư của người dùng
    ///     USER    =>  BALANCE
    mapping(address => uint256) public balances;
    bool private lock;

    /// @notice gửi ether vào contract
    /// @dev mong muốn nó hoạt động tốt khi thực hiện nhiều lần
    function addEther() external payable noReentrancy {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
    }

    /// @notice sử dụng để rút tiền khỏi hợp đồng
    /// @param amount là số lượng muốn rút. Không thể rút nếu vượt quá số dư
    function removeEther(uint256 amount) external payable noReentrancy {
        require(amount <= balances[msg.sender], "Not enough balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    modifier noReentrancy() {
        require(!lock, "Reentrant call");
        lock = true;
        _;
        lock = false;
    }
}
