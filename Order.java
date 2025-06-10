package com.example.model;

import java.math.BigDecimal;
import java.util.Date;

public class Order {
    private Integer id;
    private Integer userId;
    private Integer concertId;
    private Integer quantity;
    private BigDecimal totalPrice;
    private Integer status;  // 1:已预订 2:已支付 3:已取消
    private Date createTime;
    
    // 关联属性
    private Concert concert;
    private String username;
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public Integer getConcertId() {
        return concertId;
    }
    
    public void setConcertId(Integer concertId) {
        this.concertId = concertId;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setStatus(Integer status) {
        this.status = status;
    }
    
    public Date getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
    
    public Concert getConcert() {
        return concert;
    }
    
    public void setConcert(Concert concert) {
        this.concert = concert;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
} 
