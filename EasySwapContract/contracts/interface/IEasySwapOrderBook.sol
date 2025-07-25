// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OrderKey, Price, LibOrder} from "../libraries/LibOrder.sol";

// EasySwap订单簿核心接口, 负责NFT交易订单的全生命周期管理，包括创建、取消、编辑和匹配功能
interface IEasySwapOrderBook {
    /**
     * @notice 创建多个订单并转移相关资产。
     * @dev 若Side=List（挂单），需先授权EasySwapOrderBook合约（创建挂单会将NFT转入订单池）。
     * @dev 若Side=Bid（买单），需传入{value}：买单价格（同理，创建买单会将ETH转入订单池）。
     * @dev order.maker必须为msg.sender。
     * @dev order.price不能为0。
     * @dev order.expiry需大于block.timestamp，或设为0。
     * @dev order.salt不能为0。
     * @param newOrders 多个订单结构数据。
     * @return newOrderKeys 按顺序返回订单的唯一ID，若ID为空则对应订单创建失败。
     */
    function makeOrders(
        LibOrder.Order[] calldata newOrders
    ) external payable returns (OrderKey[] memory newOrderKeys);

     /**
     * @notice 批量取消指定订单密钥的订单
     * @dev 仅订单创建者(maker)或授权地址可取消订单；系统会验证订单状态（必须为活跃状态且未过期）
     * @dev 取消成功后，对应资产（NFT/ETH）将立即返还至原持有者账户
     * @param orderKeys 要取消的订单密钥数组（长度限制：单次最多100个订单）
     * @return successes 布尔值数组，按输入顺序指示每个订单的取消结果（true=成功，false=失败）
     */
    function cancelOrders(
        OrderKey[] calldata orderKeys
    ) external returns (bool[] memory successes);

    /**
    * @notice 通过订单密钥批量编辑多个订单
    * @dev 仅订单创建者(maker)或授权地址可执行编辑操作
    * @dev 新订单的saleKind、side、maker和nft必须与旧订单完全匹配，否则编辑会被跳过；仅允许修改价格参数
    * @dev 新订单的expiry时间戳和salt值可以重新生成，建议使用新的随机salt值
    * @dev 注意：该函数为payable，编辑买单(Bid)时需确保发送足够的ETH以匹配新价格
    * @param editDetails 包含旧订单密钥和新订单信息的编辑详情数组，格式为LibOrder.EditDetail结构体
    * @return newOrderKeys 按顺序返回编辑后新订单的唯一ID数组，空ID表示对应订单编辑失败
    */
    function editOrders(
        LibOrder.EditDetail[] calldata editDetails
    ) external payable returns (OrderKey[] memory newOrderKeys);


    /**
     * @notice 匹配并执行卖单与买单之间的交易
     * @dev 系统会验证订单匹配性（价格、NFT、有效期等）并执行资产转移
     * @dev 仅授权的匹配器(matcher)或合约自身可调用此函数
     * @param sellOrder 卖单订单结构体，包含卖家地址、NFT信息和出售价格
     * @param buyOrder 买单订单结构体，包含买家地址、出价金额和支付信息
     * @dev 函数为payable，用于处理买单支付的ETH转账给卖家
     */
    function matchOrder(
        LibOrder.Order calldata sellOrder,
        LibOrder.Order calldata buyOrder
    ) external payable;

    /**
     * @notice 原子性地匹配多个订单
     * @dev 购买NFT时：使用有效的卖单(sellOrder)并构造匹配的买单(buyOrder)进行订单匹配
     * @dev    买单参数要求：side = Bid, saleKind = FixedPriceForItem, maker = 调用者地址
     * @dev    必须满足：nft与price值和卖单相同，expiry > 当前区块时间戳，salt不为0
     * @dev 出售NFT时：使用有效的买单(buyOrder)并构造匹配的卖单(sellOrder)进行订单匹配
     * @dev    卖单参数要求：side = List, saleKind = FixedPriceForItem, maker = 调用者地址
     * @dev    必须满足：nft与price值和买单相同，expiry > 当前区块时间戳，salt不为0
     * @param matchDetails 包含待匹配卖单和买单详情的MatchDetail结构体数组
     * @return successes 按顺序返回每个匹配操作的成功状态数组
     */
    function matchOrders(
        LibOrder.MatchDetail[] calldata matchDetails
    ) external payable returns (bool[] memory successes);
}
