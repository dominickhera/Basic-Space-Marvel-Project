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
    let eventsURL = URL(string: "https://gateway.marvel.com/v1/public/characters/1011334/events")!
    let comicsURL = URL(string: "https://gateway.marvel.com/v1/public/characters/1011334/comics?apikey=publicAPIKey&ts=7c4e2e3d54b563765f6b9575ee3169a7&hash=7c4e2e3d54b563765f6b9575ee3169a7&offset=0&limit=2")!
    var testCharacter: Character?
    var apiManager: APIProtocol!
    var networkManager: NetworkProtocol!
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
        let comic1 = Content(name: "Avengers: The Initiative (2007) #19", thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/d/03/58dd080719806", thumbnailExtension: "jpg"))
        let comic2 = Content(name: "Avengers: The Initiative (2007) #18 (ZOMBIE VARIANT)", thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/1/10/4e94a23255996", thumbnailExtension: "jpg"))
        let event1 = Content(name: "Secret Invasion", thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/6/70/51ca1749980ae", thumbnailExtension: "jpg"))
        let comics = ContentCollection(available: 2, items: [comic1, comic2])
        let events = ContentCollection(available: 1, items: [event1])
        testCharacter = Character(id: 1011334, name: "3-D Man", characterDescription: "", thumbnail: Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", thumbnailExtension: "jpg"), comics: comics, events: events)
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
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testGetHeroList_Fail() throws
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
        
        guard let response = HTTPURLResponse(url: heroListURL, statusCode: 400, httpVersion: nil, headerFields: nil) else { return }

        let mockData: Data = heroData!
                
        MockURLProtocol.requestHandler =
        {
            request in
            
            return (response, mockData)
        }
        
        apiManager.getHeroList(pageCount: 0)
        {
            heroList, error in
            
            XCTAssertNotEqual(responseModel?.count, heroList?.count)
        }
        
    }
    
    func testGetComicContent_Success() throws
    {
        var contentData: Data?
        var expectedComicsArray: [Content]?
        if let path = bundle.url(forResource: "ComicContent", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawDetailResponseModel.self, from: data)
                contentData = data
                expectedComicsArray = response.nestedData.results
            }
            catch
            {
                XCTAssert(false)
            }
        }
        
        guard let response = HTTPURLResponse(url: comicsURL, statusCode: 200, httpVersion: nil, headerFields: nil) else { return }

        let mockData: Data = contentData!
                
        MockURLProtocol.requestHandler =
        {
            request in
            
            return (response, mockData)
        }
               
        let expectation = XCTestExpectation(description: "response")
        
        apiManager.getContentList(pageCount: 0, hero: testCharacter!, contentType: .comics)
        {
            contentList, error in
            
            XCTAssertEqual(expectedComicsArray?.count, contentList?.count)
            expectation.fulfill()
        }
        
       wait(for: [expectation], timeout: 2)
    }
    
    func testGetComicContent_Fail() throws
    {
        var contentData: Data?
        var expectedComicsArray: [Content]?
        if let path = bundle.url(forResource: "ComicContent", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawDetailResponseModel.self, from: data)
                contentData = data
                expectedComicsArray = response.nestedData.results
            }
            catch
            {
                XCTAssert(false)
            }
        }
        
        guard let response = HTTPURLResponse(url: comicsURL, statusCode: 400, httpVersion: nil, headerFields: nil) else { return }

        let mockData: Data = contentData!
                
        MockURLProtocol.requestHandler =
        {
            request in
            
            return (response, mockData)
        }
               
        let expectation = XCTestExpectation(description: "response")
        
        apiManager.getContentList(pageCount: 0, hero: testCharacter!, contentType: .comics)
        {
            contentList, error in
            
            XCTAssertNotEqual(expectedComicsArray?.count, contentList?.count)
            expectation.fulfill()
        }
        
       wait(for: [expectation], timeout: 2)
    }
    
    func testGetEventsContent_Success() throws
    {
        var contentData: Data?
        var expectedEventsArray: [Content]?
        if let path = bundle.url(forResource: "EventsContent", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawDetailResponseModel.self, from: data)
                expectedEventsArray = response.nestedData.results
                contentData = data
            }
            catch
            {
                XCTAssert(false)
            }
        }
        
        guard let response = HTTPURLResponse(url: eventsURL, statusCode: 200, httpVersion: nil, headerFields: nil) else { return }

        let mockData: Data = contentData!
                
        MockURLProtocol.requestHandler =
        {
            request in
            
            return (response, mockData)
        }
               
        let expectation = XCTestExpectation(description: "response")
        
        apiManager.getContentList(pageCount: 0, hero: testCharacter!, contentType: .events)
        {
            contentList, error in
            
            XCTAssertEqual(contentList?.count, expectedEventsArray?.count)
            expectation.fulfill()
        }
    }
    
    func testGetEventsContent_Fail() throws
    {
        var contentData: Data?
        var expectedEventsArray: [Content]?
        if let path = bundle.url(forResource: "EventsContent", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawDetailResponseModel.self, from: data)
                expectedEventsArray = response.nestedData.results
                contentData = data
            }
            catch
            {
                XCTAssert(false)
            }
        }
        
        guard let response = HTTPURLResponse(url: eventsURL, statusCode: 400, httpVersion: nil, headerFields: nil) else { return }

        let mockData: Data = contentData!
                
        MockURLProtocol.requestHandler =
        {
            request in
            
            return (response, mockData)
        }
               
        let expectation = XCTestExpectation(description: "response")
        
        apiManager.getContentList(pageCount: 0, hero: testCharacter!, contentType: .events)
        {
            contentList, error in
            
            XCTAssertNotEqual(contentList?.count, expectedEventsArray?.count)
            expectation.fulfill()
        }
    }
}
