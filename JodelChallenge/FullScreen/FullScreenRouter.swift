//
//  FullScreenRouter.swift
//  JodelChallenge
//
//  Created by Apurva Kochar on 4/30/18.
//  Copyright (c) 2018 Jodel. All rights reserved.
//


import UIKit

protocol FullScreenDataPassing
{
  var dataStore: FullScreenDataStore? { get }
}

class FullScreenRouter: FullScreenDataPassing
{
  var dataStore: FullScreenDataStore?
  
}
