# Description:
#   Records messages containing #success or #lessonlearned on a Google form.
# Commands:
#   #success - records the entire message as a success story.
#   #lessonlearned - records the entire message as a lesson learned.
#   #nowreading - records the entire message as a lesson learned


module.exports = (robot) ->
    robot.hear /.*#((success)|(lessonlearned)|(nowreading)|(nowlistening)).*/i, (msg) ->
        user = msg.message.user.name
        data =
            type: msg.match[1],
            text: msg.message.text,
            username: user,
        uri = "http://hashtag-listener.herokuapp.com/api"
        apikey = process.env.HUBOT_HASHTAG_LISTENER_KEY
        robot.http(uri)
             .header('Authorization', apikey)
             .post(JSON.stringify(data)) (err, res, body) ->
                robot.logger.debug body
                parsed = JSON.parse(body)
                if parsed.success
                    msg.send "Story recorded, #{user}!"
                    return
                msg.send "Something went wrong with recording your story: #{err}"
