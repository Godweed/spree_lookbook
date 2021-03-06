module Spree
  module Admin
    module Lookbooks
      class KitsController < ResourceController

        before_action :load_lookbook, except: :add_product
        before_action :setup_taxons_correctly, only: :update
        respond_to :js, only: [:add_product]

        def index
          @kits = Spree::Kit.all
        end

        #retourne un js qui pop une ligne dans un tableau
        def add_product
          @product = Spree::Product.find(params[:product_id])

          puts ("WTTTTFFFFFFFFFFF")
          puts @product.inspect
          respond_to do |format|
            format.js {}
          end


        end

        def load_lookbook
          @lookbook = Lookbook.friendly.find(params[:lookbook_id])
        end


        def create
          super
          @lookbooks_kit.lookbooks << @lookbook
          @lookbooks_kit.save
        end

        def update_positions
          ActiveRecord::Base.transaction do
            params[:positions].each_with_index do |id, index|
              puts id
              puts index
              @lookbook.spree_kit_lookbook.find_by(kit_id: id).update(position: index+1)
            end
          end

          respond_to do |format|
            format.js { render text: 'Ok' }
          end
        end

        def update_product_positions
          @kit = Spree::Kit.friendly.find(params[:kit_id])
          ActiveRecord::Base.transaction do
            params[:positions].each_with_index do |id, index|
              puts id
              puts index
              @kit.spree_kits_products.find_by(spree_product_id: id).update(position: index+1)
            end
          end

          respond_to do |format|
            format.js { render text: 'Ok' }
          end
        end

        def find_resource

          Spree::Kit.friendly.find(params[:id])
        end

        private
        def model_class
          Spree::Kit
        end

        def setup_taxons_correctly
          if params[:kit][:taxon_ids].present?
            params[:kit][:taxon_ids] = params[:kit][:taxon_ids].split(',')
          end
        end

        def permitted_resource_params
          params["kit"].present? ? params.require("kit").permit! : ActionController::Parameters.new
        end

        def location_after_save
          edit_admin_lookbook_path(@lookbook)
        end

        def find_resource

          if params[:id]
            Spree::Kit.friendly.find(params[:id])
          else
            Spree::Kit.friendly.find(params[:kit_id])

          end
        end

      end
    end
  end
end
