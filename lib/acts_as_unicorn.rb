module ActsAsUnicorn
  
  def self.included(base)
    base.send :class_inheritable_hash, :unicorn_options
    base.unicorn_options = {}
    
    base.send :helper_method,  :unicorn_html
    
    base.send :include, InstanceMethods
    base.send :extend,  ClassMethods
  end

  module ClassMethods
    
    # Cornify your app. Appends a unicorn generator link to the top of the page
    # == Args
    # +link_text+ - the text or html that you want to appear in the link. Defaults to cornify!
    # +filter_options+ - options like <tt>:only</tt> and <tt>:except</tt> to append to your filter
    # == Examples
    # Add unicorn generators to all of your actions with link text 'OMG UNICORNS' 
    #  class UnicornController
    #    acts_as_unicorn 'OMG UNICORNS'
    #  end
    #
    # Add a link with text UNICORN for +my_special_action+
    #  acts_as_unicorn 'UNICORN', :only => :my_special_action
    #
    # Add a unicorn generator to all actions except +non_unicorn+ using the cornify graphic
    #  acts_as_unicorn :except => :stupid_not_unicorn_action
    # 
    # == Custom Unicorn links
    # Override the link text to be the action name and UNICORN
    #   def unicorn_link_text
    #     "#{action_name} UNICORN"
    #   end
    # Override the unicorn html to be fun
    #  def unicorn_html
    #    "I LOVE UNICORNS"
    #  end
    #
    # == In your views
    # <%= unicorn_html %>
    def acts_as_unicorn(*args)
      self.unicorn_options = {:link_text => args.shift} if args.first.is_a?(String)
      after_filter :insert_unicorn_html, (args.first||{})
    end
  end
  
  # InstanceMethods that can be overriden by the controller
  # to control unicorn generation
  module InstanceMethods
    #the unicorn link text
    def unicorn_link_text
      unicorn_options[:link_text]||'<img src="http://www.cornify.com/assets/cornify.gif" width="61" height="16" border="0" alt="Cornify" />'
    end
    
    #Generates the unicorn html
    #TODO: use real templates!
    def unicorn_html
       unicorn_html = '<a href="http://www.cornify.com" onclick="cornify_add();return false;">' 
       unicorn_html << unicorn_link_text
       unicorn_html << '</a><script type="text/javascript" src="http://www.cornify.com/js/cornify.js"></script>'
       unicorn_html
    end
    
    #add the unicorn generator link to the top of your page
    def insert_unicorn_html
      #oh no string concatination. my unicorns aren't scaling
      response.body = unicorn_html + response.body.to_s
    end
  end
end

ActionController::Base.send :include, ActsAsUnicorn