//
//  File.swift
//  SFTabBar
//
//  Created by Adam Jones on 8/31/25.
//


Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .foregroundColor(isSelected ? color : .primary)
                .font(.system(size: 16, weight: weight))