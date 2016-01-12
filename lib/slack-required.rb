#!/usr/bin/env ruby

require 'find'

class SlackRequired

  def initialize(configuration_file)
    @repository = IO.readlines(configuration_file)[1].strip!
    @includedFileExtensions = IO.readlines(configuration_file)[3].chomp.split(",")
    @excludedFileNames = IO.readlines(configuration_file)[5].chomp.split(",")
    @excludedDirectories = IO.readlines(configuration_file)[7].chomp.split(",")
  end

  def Repository
    @repository
  end

  def IncludedFileExtensions
    @includedFileExtensions
  end

  def ExcludedFileNames
    @excludedFileNames
  end

  def ExcludedDirectories
    @excludedDirectories
  end

  def CorrectFile
    @infofile
  end

  def SlackRequiredFile
    @slack_required
  end

  def CreateSlackRequired
    @createSlackRequired = File.open(@slack_required, "w").close()
  end

  def EmptySlackRequired
    @emptySlackRequired = File.truncate(@slack_required, 0)
  end

  def DestroySlackRequired
    @destroySlackRequired = File.delete(@slack_required)
  end

  def RecurseTree
    Find.find(@repository) do |path|
      if FileTest.directory?(path)
        # Black list exludes
        if @excludedFileNames.include?(File.basename(path.downcase))
        Find.prune
        elsif @excludedDirectories.include?(File.basename(path.downcase))
          Find.prune
        else
          next
        end
      else
        filetype = File.basename(path.downcase).split(".").last
        if @includedFileExtensions.include?(filetype)

          @infofile = File.absolute_path(path)
          @infofile_dir = File.dirname(@infofile)
          @slack_required = @infofile_dir + "/" + "slack-required"

          @requires_regex = /REQUIRES\=\".*\"/
          @read_infofile = File.readlines(@infofile)
          @matches = @read_infofile.select { |requires| requires[@requires_regex] }
        end
      end
    end
  end
end

