//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 1/4/21.
//

import UIKit
import QuizEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var quiz: Quiz?
    private lazy var navigationController = UINavigationController()


    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        startNewQuiz()
    }
    
    private func startNewQuiz() {
        let question1 = Question.singleAnswer("What is the longest that an elephant has ever lived?")
        let question2 = Question.multipleAnswer("Test multiple answer question")
        let questions = [question1, question2]
        
        let option1 = "17 years"
        let option2 = "49 years"
        let option3 = "86 years"
        let options1 = [option1, option2, option3]
        
        let option4 = "first"
        let option5 = "second"
        let option6 = "third"
        let options2 = [option4, option5, option6]
        
        let options = [question1: options1, question2: options2]
        let correctAnswers = [(question1, [option3]), (question2, [option4, option6])]
        
        let factory = iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers, playAgain: startNewQuiz)
        let delegate = NavigationControllerRouter(navigationController, factory: factory)
        
        quiz = Quiz.start(questions: questions, delegate: delegate, dataSource: delegate)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

