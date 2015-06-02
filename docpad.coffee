# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
    # =================================
    # Template Data
    # These are variables that will be accessible via our templates
    # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:
        site:
            url: 'http://www.ramjeeganti.com'
            author: 'Ramjee Ganti'
            twitter: 'gantir'
            twitterUrl: 'https://twitter.com/gantir'
            github: 'gantir'
            githubUrl: 'https://github.com/gantir'
            email: 'hello@ramjeeganti.com'
            emailUrl: 'mailto:hello@ramjeeganti.com'
            feedUrl: '/feed'
            title: 'Unknown Unknown -- rAmg' 
            description: 'Unknown Unknown -- rAmg'
            tagline: 'Unknown Unknown'
            nav: [
                name: 'Home'
                url: '/'
                icon: 'icon-home'
            ,
                name: 'About'
                url: '/'
                icon: 'icon-home'
            ,
                name: 'My Stories'
                url: 'http://netherstories.blogspot.in/'
                icon: 'icon-pencil'
            ]
            services:
                twitterTweetButton: 'gantir'
                twitterFollowButton: 'gantir'
                githubFollowButton: 'gantir'
                disqus: 'unknownunknown'
                googleAnalytics: 'UA-40785803-1'

            social: [
                name: 'Github'
                url: 'https://github.com/gantir'
                icon: 'icon-github-sign'
            ,
                name: 'Twitter'
                url: 'https://twitter.com/gantir'
                icon: 'icon-twitter-sign'
            ,
                name: 'Feed'
                url: '/feed'
                icon: 'icon-rss-sign'
            ,
                name: 'Email'
                url: 'mailto:hello@ramjeeganti.com'
                icon: 'icon-envelope'
            ]
            
            googleAnalytics: 'UA-40785803-1'

        # -----------------------------
        # Helper Functions

        # Get the prepared site/document title
        # Often we would like to specify particular formatting to our page's title
        # we can apply that formatting here
        getPreparedTitle: ->
            # if we have a document title, then we should use that and suffix the site's title onto it
            if @document.title
                "#{@document.title} | #{@site.title}"
            # if our document does not have it's own title, then we should just use the site's title
            else
                @site.title

        # Get the prepared site/document description
        getPreparedDescription: ->
            # if we have a document description, then we should use that, otherwise use the site's description
            @document.description or @site.description

        # Get the prepared site/document keywords
        getPreparedKeywords: ->
            # Merge the document keywords with the site keywords
            @site.keywords.concat(@document.keywords or []).join(', ')

        getGithubPath: ->
            "https://github.com/troykershaw/troykershaw-website/edit/master/src/documents/#{@document.relativePath}"

    # Ignore Custom Patterns
    # Can be set to a regex of custom patterns to ignore from the scanning process
    ignoreCustomPatterns: /DRAFT/

    # =================================
    # Collections

    collections:
        posts: ->
            @getCollection("html").findAllLive({relativeOutDirPath: 'blog'}, [date:-1])
    

    # =================================
    # Plugins

    plugins:
        navlinks:
          collections:
            posts: -1
        cleanurls:
            trailingSlashes: false
        highlightjs:
            aliases:
                csharp: 'cs'



    # =================================
    # DocPad Events

    # Here we can define handlers for events that DocPad fires
    # You can find a full listing of events on the DocPad Wiki
    events:
        # Write After
        # Used to minify our assets with grunt
        writeAfter: (opts,next) ->
            # Prepare
            balUtil = require('bal-util')
            docpad = @docpad
            rootPath = docpad.config.rootPath

            command = ["#{rootPath}/node_modules/.bin/grunt", 'build']
            # Execute
            balUtil.spawn(command, {cwd:rootPath,output:true}, next)
            # Chain
            @
}

# Export the DocPad Configuration
module.exports = docpadConfig