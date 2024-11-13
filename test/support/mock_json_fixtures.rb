module MockJsonFixtures
  def json_mocks(pathname)
    File.read(mocks_path_for(pathname))
  end

  private

  def mocks_path_for(pathname)
    File.join(File.dirname(__FILE__), "/mocks/", pathname)
  end
end
