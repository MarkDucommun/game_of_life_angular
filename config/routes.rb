Rails.application.routes.draw do
  root 'angular#index'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end
