// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { LibOrder, OrderKey } from "../libraries/LibOrder.sol";

// NFT marketplace项目中的订单资金管理模块，主要负责处理订单相关的资产（ETH和NFT）管理
interface IEasySwapVault {
    /**
     * @notice 查询订单的资产余额信息
     * @param orderKey 订单的唯一标识ID
     * @return ETHAmount 订单中包含的ETH数量
     * @return tokenId 订单中NFT的tokenId
     */
    function balanceOf(
        OrderKey orderKey
    ) external view returns (uint256 ETHAmount, uint256 tokenId);

    /**
     * @notice 存款ETH到订单中，当创建一个Bid订单时调用。
     * @param orderKey 订单的唯一标识ID
     * @param ETHAmount 存款的ETH数量
     */
    function depositETH(OrderKey orderKey, uint256 ETHAmount) external payable;

    /**
     * @notice 当订单被取消或部分成交时，从订单中提取ETH
     * @param orderKey 订单的唯一标识ID
     * @param ETHAmount 要提取的ETH数量
     * @param to 接收ETH的地址
     */
    function withdrawETH(
        OrderKey orderKey,
        uint256 ETHAmount,
        address to
    ) external;

    /**
     * @notice 创建挂单时将NFT存入订单
     * @param orderKey 订单的唯一标识ID
     * @param from NFT所有者的地址
     * @param collection NFT集合的地址
     * @param tokenId NFT的tokenId
     */
    function depositNFT(
        OrderKey orderKey,
        address from,
        address collection,
        uint256 tokenId
    ) external;

     /**
     * @notice 当订单被取消时，从订单中提取NFT
     * @param orderKey 订单的唯一标识ID
     * @param to 接收NFT的地址
     * @param collection NFT集合的地址
     * @param tokenId NFT的tokenId
     */
    function withdrawNFT(
        OrderKey orderKey,
        address to,
        address collection,
        uint256 tokenId
    ) external;

    /**
     * @notice 编辑订单中的NFT，当编辑订单时调用
     * @param oldOrderKey 旧订单的唯一标识ID
     * @param newOrderKey 新订单的唯一标识ID
     */
    function editNFT(OrderKey oldOrderKey, OrderKey newOrderKey) external;

    /**
     * @notice 编辑订单时修改订单中的ETH
     * @param oldOrderKey 订单的唯一标识ID
     * @param newOrderKey 新的订单唯一标识ID
     * @param oldETHAmount 订单中原有的ETH数量
     * @param newETHAmount 订单中更新后的ETH数量
     * @param to 接收ETH的地址
     */
    function editETH(
        OrderKey oldOrderKey,
        OrderKey newOrderKey,
        uint256 oldETHAmount,
        uint256 newETHAmount,
        address to
    ) external payable;

    /**
     * @notice 批量转移ERC721 NFT
     * @param to 接收NFT的地址
     * @param assets NFT信息数组，包含每个NFT的集合地址和tokenId
     */
    function batchTransferERC721(
        address to,
        LibOrder.NFTInfo[] calldata assets
    ) external;

    /**
     * @notice 转移单个ERC721 NFT
     * @param from NFT所有者地址
     * @param to 接收NFT的地址
     * @param assets NFT资产信息，包含NFT集合地址和tokenId
     */
    function transferERC721(
        address from,
        address to,
        LibOrder.Asset calldata assets
    ) external;
}
