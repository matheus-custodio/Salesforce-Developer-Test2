public class NationalHolidayScheduler implements Schedulable, Database.AllowsCallouts {
    public void execute(SchedulableContext ctx) {
        NationalHolidayService.getHolidays(String.valueOf((System.Today().year())));
    }
}