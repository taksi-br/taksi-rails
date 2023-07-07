# Taksi Rails [![Gem Version](https://badge.fury.io/rb/taksi-rails.svg)](https://badge.fury.io/rb/taksi-rails) [![CI](https://github.com/taksi-br/taksi-rails/actions/workflows/ci.yml/badge.svg)](https://github.com/taksi-br/taksi-rails/actions/workflows/ci.yml)

A rails engine/railtie to the Taksi framework.

It provides controllers and other tools to use the Taksi toolset into rails. This repository, as the main lib taksi-ruby are under development, it's not recommended to use it in production yet.

## Usage

Mount the engine on your ruby application to expose the endpoints to load skeletons and data.

```ruby
Rails.application.routes.draw do
  mount Taksi::Engine => '/taksi'
end
```

## Supported Ruby versions

This library officially supports the following Ruby versions:

  * MRI `>= 2.7`
