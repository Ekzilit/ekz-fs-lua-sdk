package "ekz.sdk.event"
import "ekz.sdk.Map"
public.class("EventDispatcher") {

  private.Map("subscribers", {});

  public.method("subscribe", function(subscriber, event)
    if event == nil then error("To subscribe event is needed") end
    if table.contains(subscribers, event) then
      if not table.contains(subscribers[event], subscriber) then
        table.insert(subscribers[event], subscriber)
      end
    else
      this.subscribers[event] = {}
      table.insert(subscribers[event], subscriber)
    end
  end);

  public.method("unsubscribe", function(subscriber, event)
    if event == nil then
      unsubscribeFromAllEvents(subscriber)
    else
      unsubscribeFromEvent(subscriber, event)
    end
  end);

  private.method("unsubscribeFromAllEvents", function(subscriber)
    for _, v in pairs(subscribers) do
      table.removeElement(v, subscriber)
    end
  end);

  private.method("unsubscribeFromEvent", function(subscriber, event)
    if event == nil then error("To unsubscribe by event event is needed") end
    table.removeElement(subscribers[event], subscriber)
  end);

  public.method("fireEvent", function(event, ...)
    if subscribers[event] ~= nil then
      for _, subscriber in pairs(subscribers[event]) do
        --must be public
        if subscriber[event] == nil then
          error("Subscriber does not have method to handle event " .. event)
        end
        subscriber[event](...)
      end
    else
      --log no subscribers
    end
  end);
}
