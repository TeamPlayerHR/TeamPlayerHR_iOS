//
//  InitialHomeModel.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/06/21.
//

import Foundation
import UIKit

struct countryStruct {
    var title:String = ""
    var id: Int = 0
}

struct profileStruct {
    var title:String = ""
    var first_name:String = ""
    var last_name:String = ""
    var phone:String = ""
    var email:String = ""
    var profession:String = ""
    var image:String = ""
    var imId:String = ""
    var professionId:Int = 0
    var address:String = ""
    var cv:String = ""
    var company:String = ""
    var country:String = ""
    var city:String = ""
    var state:String = ""
}

struct demoQuestionStruct {
    var question:String = ""
    var maxanswers:String = ""
    var timelimit:String = ""
    var subpart:String = ""
    var answers = [demoAnswerStruct]()
    var questionid:String = ""
    
}

struct demoAnswerStruct {
    var answerId:String = ""
    var sortorder:String = ""
    var image:String = ""
    var created_at:String = ""
    var answer:String = ""
    var questionid:String = ""
    var status:Bool = false
    var updated_at:String = ""
}

struct inviteGroupStruct {
    var id:String = ""
    var name:String = ""
    var max_size:String = ""
    var survey_progress:Bool = false
    
}

struct pendingGroupStruct {
    var id:String = ""
    var name:String = ""
    var max_size:String = ""
    var code:String = ""
    
}

struct inviteParticipantStruct {
    var id:String = ""
    var user_name:String = ""
    var survey_progress:Bool = false
    var email:String = ""
    
}

struct inviteTeamStruct {
    var id:String = ""
    var group_id:String = ""
    var name:String = ""
    var teamCount:String = ""
    var userList:[teamUserListStruct] = [teamUserListStruct]()
}

struct teamUserListStruct {
    var id:String = ""
    var user_type:String = ""
    var user_name:String = ""
    var group_id:String = ""
    var subgroup_id:String = ""
    var user_id:String = ""
}

struct showInviteeListStruct {
    var id:String = ""
    var email:String = ""
    var on_date:String = ""
    var group_id:String = ""
    
}

struct newsListStruct {
    var id:String = ""
    var title:String = ""
    var description:String = ""
    var feature_image:String = ""
    
}

struct subscriptionListStruct {
    var frequency_type:String = ""
    var title:String = ""
    var amount:String = ""
    var duration:String = ""
    var detail:String = ""
    var id:String = ""
    
}

struct purchaseHistoryStruct {
    var amount:String = "N/A"
    var on_date:String = "N/A"
    var no_of_participant:String = "N/A"
    var title:String = ""
    var detail:String = ""
}

struct purchasePlansStruct {
    var id:String = ""
    var name:String = ""
    var number_survay:String = ""
    var amount:String = ""
    var plan_type:String = ""
}
