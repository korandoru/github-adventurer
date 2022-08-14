#!/usr/bin/env bash

# Copyright 2022 Korandoru Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o xtrace

( jq -c "
[
    (\"$1\" | scan(\"[0-9]+-[0-9]+-[0-9]+-[0-9]+\")),
    .id,
    .actor.id,
    .repo.id,
    .type,
    .actor.login? // .actor_attributes.login? // (.actor | strings) // null,
    .repo.name? // (.repository.owner? + \"/\" + .repository.name?) // null,
    .created_at,
    .payload.updated_at? // .payload.comment?.updated_at? // .payload.issue?.updated_at? // .payload.pull_request?.updated_at? // null,
    .payload.action,
    .payload.comment.id,
    .payload.review.body // .payload.comment.body // .payload.issue.body? // .payload.pull_request.body? // .payload.release.body? // null,
    .payload.comment?.path? // null,
    .payload.comment?.position? // null,
    .payload.comment?.line? // null,
    .payload.ref? // null,
    .payload.ref_type? // null,
    .payload.comment.user?.login? // .payload.issue.user?.login? // .payload.pull_request.user?.login? // null,
    .payload.issue.number? // .payload.pull_request.number? // .payload.number? // null,
    .payload.issue.title? // .payload.pull_request.title? // null,
    [.payload.issue.labels?[]?.name // .payload.pull_request.labels?[]?.name],
    .payload.issue.state? // .payload.pull_request.state? // null,
    .payload.issue.locked? // .payload.pull_request.locked? // null,
    .payload.issue.assignee?.login? // .payload.pull_request.assignee?.login? // null,
    [.payload.issue.assignees?[]?.login? // .payload.pull_request.assignees?[]?.login?],
    .payload.issue.comments? // .payload.pull_request.comments? // null,
    .payload.review.author_association // .payload.issue.author_association? // .payload.pull_request.author_association? // null,
    .payload.issue.closed_at? // .payload.pull_request.closed_at? // null,
    .payload.pull_request.merged_at? // null,
    .payload.pull_request.merge_commit_sha? // null,
    [.payload.pull_request.requested_reviewers?[]?.login],
    [.payload.pull_request.requested_teams?[]?.name],
    .payload.pull_request.head?.ref? // null,
    .payload.pull_request.head?.sha? // null,
    .payload.pull_request.base?.ref? // null,
    .payload.pull_request.base?.sha? // null,
    .payload.pull_request.merged? // null,
    .payload.pull_request.mergeable? // null,
    .payload.pull_request.rebaseable? // null,
    .payload.pull_request.mergeable_state? // null,
    .payload.pull_request.merged_by?.login? // null,
    .payload.pull_request.review_comments? // null,
    .payload.pull_request.maintainer_can_modify? // null,
    .payload.pull_request.commits? // null,
    .payload.pull_request.additions? // null,
    .payload.pull_request.deletions? // null,
    .payload.pull_request.changed_files? // null,
    .payload.comment.diff_hunk? // null,
    .payload.comment.original_position? // null,
    .payload.comment.commit_id? // null,
    .payload.comment.original_commit_id? // null,
    .payload.size? // null,
    .payload.distinct_size? // null,
    .payload.member.login? // .payload.member? // null,
    .payload.release?.tag_name? // null,
    .payload.release?.name? // null,
    .payload.review?.state? // null
]" | ./upload.sh ) || ( echo "File $1 has issues" | tee -a output.txt )
