require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @link = links(:one)
  end

  test "should get index" do
    get links_url
    assert_response :success
  end

  test "should get new" do
    get new_link_url
    assert_response :success
  end

  test "should create link" do
    assert_difference("Link.count") do
      post links_url, params: {
        link: {
          github_file_path: @link.github_file_path,
          github_repo_id: @link.github_repo_id,
          github_user_id: @link.github_user_id,
          spotify_playlist_id: @link.spotify_playlist_id,
          spotify_user_id: @link.spotify_user_id
        }
      }
    end

    assert_redirected_to link_url(Link.last)
  end

  test "should show link" do
    get link_url(@link)
    assert_response :success
  end

  test "should get edit" do
    get edit_link_url(@link)
    assert_response :success
  end

  test "should update link" do
    patch link_url(@link), params: {
      link: {
        github_file_path: @link.github_file_path,
        github_repo_id: @link.github_repo_id,
        github_user_id: @link.github_user_id,
        spotify_playlist_id: @link.spotify_playlist_id,
        spotify_user_id: @link.spotify_user_id
      }
    }
    assert_redirected_to link_url(@link)
  end

  test "should destroy link" do
    assert_difference("Link.count", -1) do
      delete link_url(@link)
    end

    assert_redirected_to links_url
  end
end
