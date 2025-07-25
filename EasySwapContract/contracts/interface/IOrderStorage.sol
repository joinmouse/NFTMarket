// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OrderKey, Price, LibOrder} from "../libraries/LibOrder.sol";

// NFT marketplace项目中的订单存储与查询模块，主要负责订单数据的管理和检索
interface IOrderStorage {
    /// @notice 查询符合条件的订单列表，支持分页查询
    /// @param collection NFT合约地址，指定要查询的NFT集合
    /// @param tokenId NFT代币ID，指定具体代币（0表示查询整个集合）
    /// @param side 订单方向，指定查询买单或卖单（LibOrder.Side枚举）
    /// @param saleKind 交易类型，指定订单的销售模式（如固定价格、拍卖等，LibOrder.SaleKind枚举）
    /// @param count 最大返回订单数量，限制查询结果的数量上限
    /// @param price 价格过滤条件，用于筛选特定价格范围内的订单
    /// @param firstOrderKey 分页查询起始键，为null时从第一个订单开始查询
    /// @return resultOrders 符合条件的订单数组
    /// @return nextOrderKey 下一页查询的起始键，若为null表示已无更多订单
    function getOrders(
        address collection,
        uint256 tokenId,
        LibOrder.Side side,
        LibOrder.SaleKind saleKind,
        uint256 count,
        Price price,
        OrderKey firstOrderKey
    ) external view returns (LibOrder.Order[] memory resultOrders, OrderKey nextOrderKey);

    /// @notice 查询指定NFT代币的最佳订单
    /// @param collection NFT合约地址，指定要查询的NFT集合
    /// @param tokenId NFT代币ID，指定具体代币
    /// @param listBid 订单方向，指定查询买单或卖单（LibOrder.Side枚举）
    /// @param saleKind 交易类型，指定订单的销售模式（如固定价格、拍卖等，LibOrder.SaleKind枚举）
    /// @return orderResult 符合条件的最佳订单
    function getBestOrder(
        address collection,
        uint256 tokenId,
        LibOrder.Side listBid,
        LibOrder.SaleKind saleKind
    ) external view returns (LibOrder.Order memory orderResult);
}
