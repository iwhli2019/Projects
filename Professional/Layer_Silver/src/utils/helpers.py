import datetime


def get_age(birthdate):
    """Calculates age from a birthdate."""
    today = datetime.date.today()
    return (
        today.year
        - birthdate.year
        - ((today.month, today.day) < (birthdate.month, birthdate.day))
    )
