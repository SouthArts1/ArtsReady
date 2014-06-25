* new
* cancelled
  * by org
  * by admin
  * by system (temporary approval expired)
  * by FATE (lapsed - unimplemented)
* disabled
* temporarily approved
* active
  * provisional active



new -> active (subscribe)
    -> temporarily approved (approve)
active -> cancelled (cancel)
       -> disabled (disable)
       -> past due (lapse)
temporarily approved -> active (subscribe)
                     -> new (revoke)
cancelled -> active (subscribe/renew/???)
          -> <prevented by code> (via approve button) (prevent this!)
disabled -> active (enable) (via approve button) (rename this)


* new
  * !active && subscriptions.empty?
* cancelled
  * !active && subscriptions.present? && !active_subscription
* temporarily approved
  * active && subscriptions.empty?
* active
  * active && subscriptions.present? && active_subscription


active | subscriptions | active_subscription | past due | status
-------+---------------+---------------------+----------+-------
false  | false         | false               |          | new
false  | false         | true                |          | <logically impossible>
false  | true          | false               |          | cancelled
false  | true          | true                |          | disabled
true   | false         | false               |          | temporarily approved
true   | false         | true                |          | <logically impossible>
true   | true          | false               |          | <prevented by code>
true   | true          | true                | false    | active
true   | true          | true                | true     | past due

