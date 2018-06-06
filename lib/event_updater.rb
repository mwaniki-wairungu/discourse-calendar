module DiscourseSimpleCalendar
  class EventUpdater
    def self.update(post)
      op = post.topic.first_post

      dates = DiscourseSimpleCalendar::Dates.extract(post.raw, post.topic_id, post.user.id)

      # if we don’t have any date it's not an event anymore
      if dates.empty?
        DiscourseSimpleCalendar::EventDestroyer.destroy(op, post.post_number.to_s)
        op.publish_change_to_clients!(:calendar_change)
        return
      end

      first_date = dates[0]
      from = Time.strptime("#{first_date["date"]} #{first_date["time"]} UTC", "%Y-%m-%d %H:%M %Z")

      if dates.count == 2
        second_date = dates[1]
        to = Time.strptime("#{second_date["date"]} #{second_date["time"]} UTC", "%Y-%m-%d %H:%M %Z")
      end

      post_number = post.post_number.to_s

      current_details = op.custom_fields[DiscourseSimpleCalendar::CALENDAR_DETAILS_CUSTOM_FIELD] ||= {}

      detail = []
      detail[DiscourseSimpleCalendar::MESSAGE_INDEX] = post.excerpt(15, strip_links: true, text_entities: true).tr("\n", " ")
      detail[DiscourseSimpleCalendar::USERNAME_INDEX] = post.user.username_lower
      detail[DiscourseSimpleCalendar::FROM_INDEX] = from.iso8601.to_s
      detail[DiscourseSimpleCalendar::TO_INDEX] = to.iso8601.to_s if to

      current_details[post_number] = detail

      op.custom_fields[DiscourseSimpleCalendar::CALENDAR_DETAILS_CUSTOM_FIELD] = current_details
      op.save_custom_fields(true)
      op.publish_change_to_clients!(:calendar_change)

      Jobs.cancel_scheduled_job(:destroy_expired_event, post_id: post.id)

      if to
        enqueue_in = (to + 1.day - Time.now.utc).seconds
      else
        enqueue_in = (from.end_of_day + 1.day - Time.now.utc).seconds
      end
      enqueue_in = 30.seconds if enqueue_in < 0

      Jobs.enqueue_in(enqueue_in.to_i, :destroy_expired_event, post_id: post.id)
    end
  end
end
