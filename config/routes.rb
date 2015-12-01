Rails.application.routes.draw do
  resources :invites
end

# ==Routes==
#   Prefix Verb   URI Pattern                 Controller#Action
#     invites GET    /invites(.:format)          invites#index
#             POST   /invites(.:format)          invites#create
#  new_invite GET    /invites/new(.:format)      invites#new
# edit_invite GET    /invites/:id/edit(.:format) invites#edit
#      invite GET    /invites/:id(.:format)      invites#show
#             PATCH  /invites/:id(.:format)      invites#update
#             PUT    /invites/:id(.:format)      invites#update
#             DELETE /invites/:id(.:format)      invites#destroy
