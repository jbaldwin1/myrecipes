require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "jon", email: "jon@example.com",
                         password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "jan", email: "jan@email.com",
               password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "jan1", email: "jan1@email.com",
               password: "password", password_confirmation: "password", admin: true)

                     
  end              
    

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "john@email.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "john1 ", email: "john1@email.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "john1", @chef.chefname
    assert_match "john1@email.com", @chef.email
  end
  
  test "accept edit attempt by admin_user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "john2 ", email: "john2@email.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "john2", @chef.chefname
    assert_match "john2@email.com", @chef.email
  end
  
  
  test "redirect edit attempt by another non-admin_user" do 
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@example.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "jon", @chef.chefname
    assert_match "jon@example.com", @chef.email
  end
end
  
