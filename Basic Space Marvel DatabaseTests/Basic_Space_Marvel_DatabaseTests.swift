//
//  Basic_Space_Marvel_DatabaseTests.swift
//  Basic Space Marvel DatabaseTests
//
//  Created by Dominick Hera on 9/7/23.
//

import XCTest
@testable import Basic_Space_Marvel_Database

final class Basic_Space_Marvel_DatabaseTests: XCTestCase {

    let heroListURL = URL(string: "https://gateway.marvel.com/v1/public/characters")!
    var apiManager: APIProtocol!
    var networkManager: NetworkManager!
    var urlSession: URLSession!
    var bundle: Bundle
    {
        Bundle(for: type(of: self))
    }
    
    override func setUpWithError() throws
    {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        networkManager = NetworkManager(session: urlSession)
        apiManager = MockAPICallManager(networkManager: networkManager)
    }

    override func tearDownWithError() throws
    {
        apiManager = nil
        networkManager = nil
    }

    func testGetHeroList_Success() throws
    {
        var heroData: Data?
        var responseModel: [Character]?
        
        if let path = bundle.url(forResource: "HeroList", withExtension: "json")
        {
            do
            {
                
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawResponseModel.self, from: data)
                responseModel = response.nestedData.results
                heroData = data
            }
            catch
            {
                XCTAssert(false)
            }
        }
        
        guard let response = HTTPURLResponse(url: heroListURL, statusCode: 200, httpVersion: nil, headerFields: nil) else { return }

        let mockData: Data = heroData!
                
        MockURLProtocol.requestHandler = 
        {
            request in
            
            return (response, mockData)
        }
               
        let expectation = XCTestExpectation(description: "response")
        
        apiManager.getHeroList(pageCount: 0)
        {
            heroList, error in
            
            XCTAssertEqual(responseModel?.count, heroList?.count)
            XCTAssert(error == nil)
        }
    }
    
    func testGetHeroList_Fail() throws
    {
        
    }
    
    func testGetComicContent_Success() throws
    {
        var expectedComicsArray: [Content]?
        if let path = bundle.url(forResource: "HeroList", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawDetailResponseModel.self, from: data)
                expectedComicsArray = response.nestedData.results
            }
            catch
            {
                XCTAssert(false)
            }
        }
    }
    
    func testGetComicContent_Fail() throws
    {
        
    }
    
    func testGetEventsContent_Success() throws
    {
        var expectedEventsArray: [Content]?
        if let path = bundle.url(forResource: "HeroList", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawDetailResponseModel.self, from: data)
                expectedEventsArray = response.nestedData.results
            } 
            catch
            {
                XCTAssert(false)
            }
        }
    }
    
    func testGetEventsContent_Fail() throws
    {
        
    }
}
