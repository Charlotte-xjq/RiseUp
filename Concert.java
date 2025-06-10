package com.example.model;

import java.math.BigDecimal;
import java.util.Date;

public class Concert {
    private Integer id;
    private String name;
    private Date date;
    private String location;
    private BigDecimal ticketPrice;
    private String image;
    private Integer remainingTickets;
    private Date createTime;
    
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public BigDecimal getTicketPrice() {
        return ticketPrice;
    }
    
    public void setTicketPrice(BigDecimal ticketPrice) {
        this.ticketPrice = ticketPrice;
    }
    
    public String getImage() {
        return image;
    }
    
    public void setImage(String image) {
        this.image = image;
    }
    
    public Integer getRemainingTickets() {
        return remainingTickets;
    }
    
    public void setRemainingTickets(Integer remainingTickets) {
        this.remainingTickets = remainingTickets;
    }
    
    public Date getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
} 
