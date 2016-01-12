require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/benchmark'

require_relative 'lib/slack-required'

describe "Test that the SlackRequired class reads the configuration file" do

  before do
    @sr = SlackRequired.new('./test/config.cfg')
    @good_extensions = ["info"]
    @bad_files = ["slack-desc", "README"]
    @bad_directories = [".git", "patches"]
  end

  it "returns ./test/SlackBuild-mock-repository as the repository" do
    @sr.Repository.must_equal "./test/SlackBuild-mock-repository"
  end

  it "returns inlcuded file extensions" do
    @sr.IncludedFileExtensions.must_equal @good_extensions
  end

  it "returns excluded File names" do
    @sr.ExcludedFileNames.must_equal @bad_files
  end

  it "returns excluded directory names" do
    @sr.ExcludedDirectories.must_equal @bad_directories
  end

end

describe "The SlackRequired class must find, create, and destroy the correct files" do

  before do
    @sr = SlackRequired.new('./test/config.cfg')
    @search = @sr.RecurseTree
    @good_file1 = "/home/facerip/Projects/Slackware/Generate-slack-required/test/SlackBuild-mock-repository/section5/app1/application.info"
    @good_file2 = "/home/facerip/Projects/Slackware/Generate-slack-required/test/SlackBuild-mock-repository/section5/app1/slack-required"
    @bad_file1 = "/home/facerip/Projects/Slackware/Generate-slack-required/test/SlackBuild-mock-repository/section5/app1/application.SlackBuild"
    @bad_file2 = "/home/facerip/Projects/Slackware/Generate-slack-required/test/SlackBuild-mock-repository/section5/app1/README"
    @bad_file3 = "/home/facerip/Projects/Slackware/Generate-slack-required/test/SlackBuild-mock-repository/section5/app1/slack-desc"
  end

  it "includes searched info files" do
    @search
    @sr.CorrectFile.must_include @good_file1
  end

  it "does not include exluded file types" do
    @search
    @sr.CorrectFile.wont_include @bad_file1
    @sr.CorrectFile.wont_include @bad_file2
    @sr.CorrectFile.wont_include @bad_file3
  end

  it "returns the path of slack-required files" do
    @search
    @sr.SlackRequiredFile.must_include @good_file2
  end

  it "returns nil if an empty slack-required file is created" do
    @search
    @sr.CreateSlackRequired.must_equal nil
  end

  it "returns 0 if a slack-required file can be emptied" do
    @search
    @sr.CreateSlackRequired
    @sr.EmptySlackRequired.must_equal 0
  end

  it "returns 1 if a slack-required file can be destroyed" do
    @search
    @sr.CreateSlackRequired
    @sr.DestroySlackRequired.must_equal 1
  end

end
