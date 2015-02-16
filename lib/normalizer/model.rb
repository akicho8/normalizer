# -*- coding: utf-8 -*-
# ActiveRecord / ActiveModel で使う
#
# ActiveRecordで使う例
#
#   class Article < ActiveRecord::Base
#     normalize_default_options.update(:blank_to_nil => true)
#
#     with_options(:strip_tags => true, :strip => true) do |o|
#       o.normalize :email, :hankaku => true
#       o.normalize :name_kana, :katakana => true
#       o.normalize :body
#     end
#   end
#
# ActiveModelで使う例(changes, before_validation が必要なのでちょっと準備が大変)
#
#   class Article
#     include ActiveModel::Validations
#     include ActiveModel::Validations::Callbacks
#     include ActiveModel::Dirty
#
#     define_attribute_methods [:email, :name_kana, :body]
#
#     attr_accessor :email, :name_kana, :body
#
#     normalize_default_options.update(:blank_to_nil => true)
#     with_options(:strip_tags => true, :strip => true) do |o|
#       o.normalize :email, :hankaku => true
#       o.normalize :name_kana, :katakana => true
#       o.normalize :body
#     end
#
#     [:email, :name_kana, :body].each do |key|
#       define_method("#{key}=") do |value|
#         unless value == send(key)
#           attribute_will_change!(key)
#           instance_variable_set("@#{key}", value)
#         end
#       end
#     end
#   end
#

require "active_support/core_ext/object/with_options"
require "active_support/core_ext/hash/keys"
require "active_support/concern"

module Normalizer
  concern :Model do
    included do
      def self.inherited(child)
        super
        child.class_eval do
          class_attribute :normalize_default_options
          self.normalize_default_options = Normalizer.default_options.dup
        end
      end
    end

    class_methods do
      def normalize(*attr_names, &block)
        options = attr_names.extract_options!
        default = options.delete(:default)
        unless respond_to?(:before_validation)
          raise NotImplementedError, "include ActiveModel::Validations::Callbacks してください"
        end
        before_validation(options.except!(:on)) do |record|
          unless record.respond_to?(:changes)
            raise NotImplementedError, "include ActiveModel::Dirty してください"
          end
          options = normalize_default_options.merge(options)
          attr_names.each do |attr_name|
            if record.changes[attr_name]
              dirty_value = record.send(attr_name)
              value = Normalizer.normalize(dirty_value, options)
              if block_given?
                value = yield(value)
              end
              Normalizer.logger.debug("Normalize finish #{record.class.name.try(:underscore)}.#{attr_name} #{dirty_value.inspect.truncate(50)} => #{value.inspect.truncate(50)}") if Normalizer.logger
              record.send("#{attr_name}=", value)
            end
            if default
              unless record.send(attr_name)
                record.send("#{attr_name}=", default)
                Normalizer.logger.debug("Normalize default set #{record.class.name.try(:underscore)}.#{attr_name} ||= #{default.inspect.truncate(50)}") if Normalizer.logger
              end
            end
          end
          true
        end
      end
    end
  end
end
