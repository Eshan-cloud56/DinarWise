"""Create the initial DinarWise household finance schema.

Revision ID: 20260728_0001
Revises:
Create Date: 2026-07-28
"""

from alembic import op

from app.models import Base

revision = "20260728_0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Metadata is the single schema definition during the initial scaffold.
    # Subsequent migrations should use explicit Alembic operations.
    Base.metadata.create_all(bind=op.get_bind())


def downgrade() -> None:
    Base.metadata.drop_all(bind=op.get_bind())
