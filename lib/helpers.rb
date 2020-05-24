
# allow partial layouts (menu/submenu)
include Nanoc::Helpers::Rendering
# generate links to specific items
include Nanoc::Helpers::LinkTo

def link_to_upper_page(text, attributes = {})
  p = @item_rep.path

  # link from each subsection to section
  if p =~ /(\/[^\/]*\/)[^\/]*\//
    target = $1

    if target == "/contribute/"
      upper = "Introduction"
    else
      upper = "Overview"
    end
  # link from each section to about page
  elsif p =~ /\/[^\/]*\//
    target = "/about/"
    upper = "About"
  end

  # set corresponding title, if not set
  if not attributes.key?(:title) then
    attributes[:title] = "Back to #{upper} page"
  end

  link_to(text, target, attributes)
end

def link_to_jenkins_master(job)
  api_url = "https://ci.easyrpg.org/view/Player/job/#{job}/lastSuccessfulBuild/api/json?tree=actions[buildsByBranchName[buildNumber]]"
  build = "none"

  res = Net::HTTP.get(URI(api_url))
  if res
    j = JSON.parse(res)
    j["actions"].each{|action|
      if action.key? "buildsByBranchName"
        if action["buildsByBranchName"].key? "origin/master"
          build = action["buildsByBranchName"]["origin/master"]["buildNumber"]
        end
      end
    }
  end
  if ! build.is_a? Numeric
    # fallback
    build = "lastSuccessfulBuild"
  end

  return "https://ci.easyrpg.org/job/#{job}/#{build}/artifact"
end
