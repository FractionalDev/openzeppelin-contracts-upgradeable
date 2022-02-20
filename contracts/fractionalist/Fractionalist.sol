/**
 * @author "Lolsborn" Steven Osborn<steven@fractionalist.co>
 * @version 1.0
 * 
 * This is a basic ERC1155 Upgradeable Contract. With Pauseable
 * and Supply features.
 */

// SPDX-License-Identifier: UNLICENSED
// OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;
import "../token/ERC1155/ERC1155Upgradeable.sol";
import "../security/PausableUpgradeable.sol";
import "../proxy/utils/Initializable.sol";

contract Fractionalist is Initializable, ERC1155Upgradeable, PausableUpgradeable {

    // solhint-disable-next-line func-name-mixedcase
    function __Fractionalist_init() internal onlyInitializing {
        __Pausable_init_unchained();
    }

    // solhint-disable-next-line func-name-mixedcase
    function __Fractionalist_init_unchained() internal onlyInitializing {
    }
    
    /**
     * @dev Keep track of total supply of tokens for each token type
     */
    mapping(uint256 => uint256) private _totalSupply;

    /**
     * @dev Total amount of tokens in with a given id.
     */
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return _totalSupply[id];
    }

    /**
     * @dev Indicates whether any token exist with a given id, or not.
     */
    function exists(uint256 id) public view virtual returns (bool) {
        return Fractionalist.totalSupply(id) > 0;
    }

    /**
     * @dev See {ERC1155-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);

        // Pauseable
        require(!paused(), "ERC1155Pausable: token transfer while paused");
        
        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 id = ids[i];
                uint256 amount = amounts[i];
                uint256 supply = _totalSupply[id];
                require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
                unchecked {
                    _totalSupply[id] = supply - amount;
                }
            }
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}