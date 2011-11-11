require 'test_helper'

class TaskTest < Test::Unit::TestCase
  def setup
    @task = Factory.build(:task)
    @task_options = Factory.attributes_for(:task)
  end

  def teardown
    @task.destroy if @task
  end

  def test_task_should_fail_save
    @task = Task.new
    assert @task.save == false
  end

  def test_task_save
    assert @task.save, @task.errors.full_messages
  end

  def test_expire!
    @task[:deadline_date] = Time.now.yesterday

    #avoid validation to mock a task with past deadline
    assert @task.save(:validate => false), @task.errors.full_messages
    assert @task[:status] == Constants::TaskStatus::OPEN
    @task.expire!
    assert @task[:status] == Constants::TaskStatus::EXPIRED
  end

  def test_cant_expire_completed
    @task[:deadline_date] = Time.now.yesterday
    @task.complete!
    
    #avoid validation to mock a task with past deadline
    assert @task.save(:validate => false), @task.errors.full_messages
    assert @task[:status] == Constants::TaskStatus::COMPLETED
    @task.expire!
    assert @task[:status] == Constants::TaskStatus::COMPLETED
  end

  def test_validate_deadline
    @task[:deadline_date] = Time.now
    assert !@task.save, @task.errors.full_messages

    @task[:deadline_date] = Time.now.yesterday
    assert !@task.save, @task.errors.full_messages

    @task[:deadline_date] = 20.days.from_now
    assert @task.save, @task.errors.full_messages
  end
  
  def test_complete
    @task.complete!
    
    assert @task.completed?
  end

  def test_should_not_endless_loop_on_save
    t = Task.new({"associated_project_name"=>"mark", "category"=>"New Project", "title"=>"p.send(:create_without_callbacks) #{rand(1000)}", "initial_reward_amount"=>"60","requirements"=>"This is a sample you can base your requirements on.\r\n                  -------------------------------------------------------------------\r\n                  - A lexer/parser/translator approach to translating Markdown to HTML\r\n                \r\n                  - Input is text formatted in Markdown.\r\n                  - Output is corresponding HTML code.\r\n                \r\n                  - Details of Markdown:\r\n                   http://daringfireball.net/projects/markdown\r\n                  - Must be implemented with a automated modern lexer/parser tool.\r\n                  These tools uses a grammar file to auto-generates the lexer/parser. Antlr is one example.\r\n                \r\n                  - Must pass the MarkdownTest unit tests as referenced here:\r\n                  http://six.pairlist.net/pipermail/markdown-discuss/2004-December/000909.html\r\n                  ", "deadline_date"=>"2010-10-24 00:00:00 UTC", "description"=>"p.send(:create_without_callbacks)\r\n                                  ", "solution_license"=>"MIT License", "solution_format"=>"Link to Source Code",             "computer_language"=>"Ruby", "profile_id" => Profile.first.id})

    assert t.save
  end
end
