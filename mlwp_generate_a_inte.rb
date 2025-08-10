# mlwp_generate_a_inte.rb

require 'json'

class ARVRModuleGenerator
  def initialize
    @module_config = {
      name: '',
      description: '',
      environment: '', # AR, VR, or MR
      platform: '', # mobile, desktop, or web
      interactions: [], # list of interaction types (e.g. touch, gaze, voice)
      assets: [] # list of asset types (e.g. 3D model, 2D image, audio)
    }
  end

  def set_module_name(name)
    @module_config[:name] = name
  end

  def set_module_description(description)
    @module_config[:description] = description
  end

  def set_environment(env)
    @module_config[:environment] = env
  end

  def set_platform(platform)
    @module_config[:platform] = platform
  end

  def add_interaction(interaction_type)
    @module_config[:interactions] << interaction_type
  end

  def add_asset(asset_type)
    @module_config[:assets] << asset_type
  end

  def generate_module
    {
      module: @module_config[:name],
      description: @module_config[:description],
      environment: @module_config[:environment],
      platform: @module_config[:platform],
      interactions: @module_config[:interactions],
      assets: @module_config[:assets]
    }.to_json
  end
end

class ARVRModuleGeneratorAPI < Grape::API
  prefix 'api'
  format :json

  resource :generate_arvr_module do
    desc 'Generate an interactive AR/VR module'
    params do
      requires :name, type: String
      requires :description, type: String
      requires :environment, type: String
      requires :platform, type: String
      requires :interactions, type: Array[String]
      requires :assets, type: Array[String]
    end
    post do
      generator = ARVRModuleGenerator.new
      generator.set_module_name(params[:name])
      generator.set_module_description(params[:description])
      generator.set_environment(params[:environment])
      generator.set_platform(params[:platform])
      params[:interactions].each do |interaction|
        generator.add_interaction(interaction)
      end
      params[:assets].each do |asset|
        generator.add_asset(asset)
      end
      generator.generate_module
    end
  end
end