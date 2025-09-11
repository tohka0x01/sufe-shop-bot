package main

import (
	"fmt"
	"log"
	"shop-bot/internal/store"
)

func main() {
	// 初始化数据库
	db, err := store.InitDB("file:/data/shop.db")
	if err != nil {
		log.Fatal("初始化数据库失败:", err)
	}

	// 查询所有产品
	var products []store.Product
	if err := db.Find(&products).Error; err != nil {
		log.Fatal("查询产品失败:", err)
	}

	fmt.Printf("数据库中共有 %d 个产品:\n", len(products))
	for _, p := range products {
		fmt.Printf("ID: %d, 名称: %s, 描述: %s, 价格: %d分, 激活: %v\n", 
			p.ID, p.Name, p.Description, p.PriceCents, p.IsActive)
	}

	// 查询可用卡密数量
	fmt.Println("\n每个产品的库存:")
	for _, p := range products {
		var count int64
		db.Model(&store.Code{}).Where("product_id = ? AND is_sold = ?", p.ID, false).Count(&count)
		fmt.Printf("产品 %s (ID:%d): %d 个可用卡密\n", p.Name, p.ID, count)
	}
}