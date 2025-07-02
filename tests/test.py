import math as m


days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
]
months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
]


def get_month(month: int) -> str:
    return months[month - 1]


def get_months() -> list[str]:
    return months


def test_get_month():
    assert get_month(1) == "January"
    assert get_month(12) == "December"
    try:
        get_month(0)
    except IndexError:
        pass
    try:
        get_month(13)
    except IndexError:
        pass


def test_get_months():
    assert get_months() == [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    ]


def test_get_day(i: int) -> str:
    return days[i]


def test_get_days():
    assert days == [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
    ]
