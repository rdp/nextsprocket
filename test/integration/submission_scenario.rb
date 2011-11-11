require "#{File.dirname(__FILE__)}/../test_helper"

class SubmissionScenario < ActionController::IntegrationTest

  test "employer creates task without preapproval payment" do
    #visit "/tasks/new"
    #fill out all fields
    #on final page, click skip and complete
  end

  test "employer creates task and preapproval payment" do
    #visit "/tasks/new"
    #fill out all fields
    #on final page, click prepay
    #it will redirect to paypal
    #email: employ_1262035883_per@nextsprocket.com
    #pass: 262035869
    # click confirm on paypal page
    #upon completion from paypal, it'll redirect back
  end

  test "programmer sees employer's listing, submits entry" do
    #programmer goes to task show page
    #clicks submits solution
    #types in project url or uploads contents
    #clicks submit
  end

  test  "employer rejects a submission with note" do
    # visit task show page
    # clicks on specific submission link
    # types in a comment, clicks save
    # clicks reject
  end

  test "employer accepts a submission that did not have preapproval payment" do
    # visit task show page
    # clicks on specific submission link
    # clicks accept and pay
    # user types in amount
    # clicks pay
    # redirect to paypal
    # login
    #email: employ_1262035883_per@nextsprocket.com
    #pass: 262035869
    # click confirm on paypal page
    #upon completion from paypal, it'll redirect back
  end

  test "employer accepts a submission that did have preapproval payment" do
    # visit task show page
    # clicks on specific submission link
    # clicks accept and pay
    # clicks pay using preapproval
    # returns back to site if preapproval was successful
    # otherwise, error msg shown
  end
end